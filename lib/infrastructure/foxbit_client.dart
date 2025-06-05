// lib/infrastructure/foxbit_client.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';                // Para gerar external_id
import '../utils/auth_helper.dart';
import '../models/sub_member.dart';
import '../models/order.dart';
import '../config.dart';                        // <-- importe o config.dart aqui

/// Classe que encapsula todas as chamadas à API da Foxbit.
class FoxbitClient {
  final String apiKey;
  final String apiSecret;
  final String baseUrl;

  FoxbitClient({
    required this.apiKey,
    required this.apiSecret,
    required this.baseUrl,
  });

  /// Retorna timestamp em segundos como string.
  String _getTimestamp() {
    final now = DateTime.now().toUtc();
    final seconds = now.millisecondsSinceEpoch ~/ 1000;
    return seconds.toString();
  }

  /// Monta headers padrão com assinatura.
  Future<Map<String, String>> _buildHeaders({
    required String method,
    required String path,
    String body = '',
  }) async {
    final timestamp = _getTimestamp();
    final signature = generateFoxbitSignature(
      secret: apiSecret,
      timestamp: timestamp,
      method: method,
      path: path,
      body: body,
    );

    return {
      'Content-Type': 'application/json',
      'X-FB-ACCESS-KEY': apiKey,
      'X-FB-ACCESS-TIMESTAMP': timestamp,
      'X-FB-ACCESS-SIGNATURE': signature,
    };
  }

  /// Cria um sub-member (KYC).
  ///
  /// Atenção: o endpoint POST /sub_member exige um objeto `id_document` completo,
  /// com telefone, CPF (tax_id_number), nome, data de nascimento etc.
  Future<SubMember> createSubMember({
    required String name,
    required String cpf,
    required String email,
    required String phone,
    required String birthDate,      // formato "YYYY-MM-DD"
    bool isPep = false,
    bool isUsPerson = false,
    String? usPersonNumber,
    Map<String, dynamic>? address,  // ex: {'zip_code': '...', 'state': '...', etc.}
  }) async {
    const path = '/sub_member';
    final url = Uri.parse('$baseUrl$path');

    // Gera external_id aleatório:
    final externalId = const Uuid().v4();

    final payloadMap = {
      'email': email,
      'external_id': externalId,
      'id_document': {
        'phone_number': phone,
        'is_pep': isPep,
        'is_us_person': isUsPerson,
        'us_person_number': isUsPerson ? usPersonNumber : null,
        'tax_id_number': cpf,
        'name': name,
        'birth_date': birthDate,
        'address': address ?? {},
      },
    };

    final payload = json.encode(payloadMap);
    final headers = await _buildHeaders(method: 'POST', path: path, body: payload);

    final response = await http.post(url, headers: headers, body: payload);

    // DEBUG: inspeciona status e body bruto
    debugPrint('DEBUG → POST $path status: ${response.statusCode}');
    debugPrint('DEBUG → POST $path body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);

      // ───────────────────────────────────────────────────────────────────────
      //  CUIDADO: O spec da Foxbit mostra que a resposta de POST /sub_member
      //  retorna diretamente um objeto com 'sn', 'email', etc. (não há nesting em 'data').
      //  Aqui, você faz data['data'], mas se a API não vier aninhada,
      //  data['data'] será null → lança NoSuchMethodError ou retorna null,
      //  e daí SubMember.fromJson receberá json == null. Isso pode gerar
      //  “NoSuchMethodError” ou "Bad state: No element" dependendo do seu modelo.
      //
      //  Antes de acessar data['data'], valide:
      // ───────────────────────────────────────────────────────────────────────
      if (data.containsKey('data') && data['data'] != null) {
        final nested = data['data'] as Map<String, dynamic>;
        return SubMember.fromJson(nested);
      } else {
        // Em sandbox, a resposta costuma vir sem “data”:
        // { "sn": "...", "email": "...", … }
        // Então use diretamente `data`:
        return SubMember.fromJson(data as Map<String, dynamic>);
      }
    } else {
      debugPrint('Erro createSubMember: ${response.statusCode} ${response.body}');
      throw Exception('Falha ao criar sub_member (status ${response.statusCode})');
    }
  }

  /// Retorna o preço do ticker (ex.: "/markets/ticker/24hr").
  Future<double> fetchPrice({required String symbol}) async {
    // O endpoint foxbitTicker já aponta para https://api.foxbit.com.br/rest/v3/markets/ticker/24hr
    final url = Uri.parse(foxbitTicker);
    final symbolLower = '${symbol.toLowerCase()}brl';

    // A assinatura para esse endpoint usa path = '/rest/v3/markets/ticker/24hr'
    final headers = await _buildHeaders(
      method: 'GET',
      path: '/rest/v3/markets/ticker/24hr',
      body: '',
    );
    final response = await http.get(url, headers: headers);

    debugPrint('DEBUG → GET /markets/ticker/24hr status: ${response.statusCode}');
    debugPrint('DEBUG → GET /markets/ticker/24hr body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final dataList = data['data'] as List<dynamic>?;

      if (dataList == null || dataList.isEmpty) {
        throw Exception('Resposta de ticker veio vazia (dataList nulo ou vazio)');
      }

      // Usa firstWhere de forma segura (com orElse retornando null):
      final item = dataList.firstWhere(
            (d) {
          final ms = d['market_symbol'] as String? ?? '';
          return ms.toLowerCase() == symbolLower;
        },
        orElse: () => null,
      );

      if (item == null) {
        // Se não encontrou, reporta para debug e retorna 0.0
        debugPrint('DEBUG → símbolo "$symbolLower" não encontrado em dataList.');
        return 0.0;
      }

      final lastTrade = (item as Map<String, dynamic>)['last_trade'] as Map<String, dynamic>?;
      if (lastTrade == null || lastTrade['price'] == null) {
        throw Exception('last_trade ou price ausente para $symbolLower');
      }

      return double.parse(lastTrade['price'].toString());
    } else {
      debugPrint('Erro fetchPrice: ${response.statusCode} ${response.body}');
      throw Exception('Falha ao buscar cotação');
    }
  }

  /// Cria uma ordem de compra ou venda via Gateway.
  Future<OrderResponse> createOrder({
    required bool isBuy,
    required String subMemberSn,
    required String taxIdNumber,
    required String name,
    required String phone,
    required String birthDate,
    required String paymentMethod,
    required String receiveAccount,
    required String quoteId,
    required Map<String, dynamic> address,
    required String transferMethod,
    required String chain,
    required String ipClient,
  }) async {
    const path = '/fiat_gateway/orders';
    final url = Uri.parse('$baseUrl$path');

    final bodyMap = {
      'tax_id_number': taxIdNumber,
      'name': name,
      'phone_number': phone,
      'birth_date': birthDate,
      'payment_method': paymentMethod,
      if (isBuy)
        'receive_address': receiveAccount
      else
        'receive_account': receiveAccount,
      'quote_id': quoteId,
      'address': address,
      'transfer_method': transferMethod,
      'ip_client': ipClient,
      'chain': chain,
    };

    final payload = json.encode(bodyMap);
    final headers = await _buildHeaders(method: 'POST', path: path, body: payload);

    final response = await http.post(url, headers: headers, body: payload);
    debugPrint('DEBUG → POST $path status: ${response.statusCode}');
    debugPrint('DEBUG → POST $path body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);

      // Normalmente, a resposta de createOrder está em "data":
      final inner = (data.containsKey('data') && data['data'] != null)
          ? data['data'] as Map<String, dynamic>
          : throw Exception('Payload “data” ausente em createOrder');

      return OrderResponse.fromJson(inner);
    } else {
      debugPrint('Erro createOrder (gateway): ${response.statusCode} ${response.body}');
      throw Exception('Falha ao criar order no gateway (status ${response.statusCode})');
    }
  }
}