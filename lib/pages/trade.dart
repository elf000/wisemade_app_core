// lib/pages/trade.dart

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';                    // <-- para gerar quoteId
import '../config.dart';                             // foxbitBaseUrl e foxbitTicker
import '../infrastructure/foxbit_client.dart';      // FoxbitClient
import 'kyc.dart';                                   // KyCPage

class TradePage extends StatefulWidget {
  final FoxbitClient foxbitClient;

  const TradePage({super.key, required this.foxbitClient});

  @override
  State<TradePage> createState() => _TradePageState();
}

class _TradePageState extends State<TradePage> {
  bool isBuy = true;
  String selectedCrypto = 'BTC';
  double lastPrice = 0.0; // última cotação em BRL
  Timer? _timer;

  final TextEditingController brlController =
  TextEditingController(text: '100.00');
  final TextEditingController cryptoController = TextEditingController();
  final TextEditingController addressController =
  TextEditingController(); // para “endereço de wallet” ou “chave PIX”

  // Apenas as 5 criptomoedas fixas
  final List<String> symbols = ['BTC', 'ETH', 'SOL', 'USDT', 'USDC'];

  final Map<String, String> cryptoNames = {
    'BTC': 'Bitcoin',
    'ETH': 'Ethereum',
    'SOL': 'Solana',
    'USDT': 'Tether',
    'USDC': 'USD Coin',
  };

  // Ícones usados no dropdown
  final Map<String, String> icons = {
    'BRL': "https://cdn-icons-png.flaticon.com/128/197/197386.png",
    'BTC': "https://cdn-icons-png.flaticon.com/128/15301/15301521.png",
    'ETH': "https://cdn-icons-png.flaticon.com/128/15301/15301597.png",
    'SOL': "https://cdn-icons-png.flaticon.com/128/15301/15301766.png",
    'USDC': "https://cdn-icons-png.flaticon.com/128/15301/15301840.png",
    'USDT': "https://cdn-icons-png.flaticon.com/128/15301/15301795.png"
  };

  @override
  void initState() {
    super.initState();
    _fetchLastPrice();
    // Atualiza a cada 2 minutos
    _timer = Timer.periodic(const Duration(minutes: 2), (_) {
      _fetchLastPrice();
    });
    brlController.addListener(_updateConversion);
  }

  @override
  void dispose() {
    _timer?.cancel();
    brlController.dispose();
    cryptoController.dispose();
    addressController.dispose();
    super.dispose();
  }

  /// Busca somente o `last_trade.price` chamando
  /// GET https://api.foxbit.com.br/rest/v3/markets/ticker/24hr
  Future<void> _fetchLastPrice() async {
    final symbolLower = '${selectedCrypto.toLowerCase()}brl';
    final url = Uri.parse(foxbitTicker);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body) as Map<String, dynamic>;
        final dataList = jsonBody['data'] as List<dynamic>?;

        if (dataList == null || dataList.isEmpty) {
          debugPrint('DEBUG → dataList vazio em ticker/24hr');
          setState(() {
            lastPrice = 0.0;
          });
          return;
        }

        final item = dataList.firstWhere(
              (d) => (d['market_symbol'] as String).toLowerCase() == symbolLower,
          orElse: () => null,
        );

        if (item != null) {
          final lastTrade = (item as Map<String, dynamic>)['last_trade']
          as Map<String, dynamic>?;
          if (lastTrade != null && lastTrade['price'] != null) {
            final fetchedPrice = double.parse(lastTrade['price'].toString());
            setState(() {
              lastPrice = fetchedPrice;
            });
            _updateConversion();
          } else {
            debugPrint('DEBUG → last_trade ou price ausente em item: $item');
            setState(() {
              lastPrice = 0.0;
            });
          }
        } else {
          debugPrint(
            'DEBUG → símbolo "$symbolLower" não encontrado em dataList.',
          );
          setState(() {
            lastPrice = 0.0;
          });
        }
      } else {
        debugPrint(
          'Erro ao chamar /markets/ticker/24hr: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Erro ao buscar last price: $e');
    }
  }

  /// Recalcula conversão BRL ↔ Crypto
  void _updateConversion() {
    final brl = double.tryParse(
      brlController.text.replaceAll(',', '.'),
    ) ??
        0.0;

    setState(() {
      if (lastPrice > 0) {
        if (isBuy) {
          // BRL → quantidade Crypto
          cryptoController.text = (brl / lastPrice).toStringAsFixed(8);
        } else {
          // Crypto digitado pelo usuário → calcula BRL
          final cryptoAmt = double.tryParse(
            cryptoController.text.replaceAll(',', '.'),
          ) ??
              0.0;
          brlController.text = (cryptoAmt * lastPrice)
              .toStringAsFixed(2)
              .replaceAll('.', ',');
        }
      } else {
        cryptoController.text = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final formattedPrice = lastPrice > 0
        ? 'R\$ ${lastPrice.toStringAsFixed(2).replaceAll('.', ',')}'
        : 'Carregando...';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Comprar ou Vender"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1) Exibe última cotação
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Preço $selectedCrypto/BRL:',
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
                Text(
                  formattedPrice,
                  style: const TextStyle(
                    color: Colors.tealAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 2) Toggle Comprar / Vender
            ToggleButtons(
              isSelected: [isBuy, !isBuy],
              onPressed: (index) {
                setState(() {
                  isBuy = index == 0;
                  _updateConversion();
                  addressController.clear(); // limpa o campo ao mudar de modo
                });
              },
              borderRadius: BorderRadius.circular(12),
              selectedColor: Colors.black,
              fillColor: Colors.tealAccent,
              textStyle: const TextStyle(fontSize: 14),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Comprar'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Vender'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 3) Dropdown com as 5 criptomoedas
            DropdownButtonFormField<String>(
              value: selectedCrypto,
              decoration: const InputDecoration(labelText: 'Criptomoeda'),
              dropdownColor: Colors.black,
              items: symbols.map((code) {
                return DropdownMenuItem(
                  value: code,
                  child: Row(
                    children: [
                      Image.network(
                        icons[code]!,
                        width: 24,
                        height: 24,
                        errorBuilder: (_, __, ___) =>
                        const SizedBox(width: 24, height: 24),
                      ),
                      const SizedBox(width: 8),
                      Text('$code - ${cryptoNames[code]}'),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedCrypto = value;
                  });
                  _fetchLastPrice();
                }
              },
            ),
            const SizedBox(height: 24),

            // 4) “De” e “Para” com ícones
            Row(
              children: isBuy
                  ? [
                Expanded(
                  child: _buildLabelTile(
                    label: 'De',
                    iconUrl: icons['BRL']!,
                    title: 'BRL',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildLabelTile(
                    label: 'Para',
                    iconUrl: icons[selectedCrypto]!,
                    title: selectedCrypto,
                  ),
                ),
              ]
                  : [
                Expanded(
                  child: _buildLabelTile(
                    label: 'De',
                    iconUrl: icons[selectedCrypto]!,
                    title: selectedCrypto,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildLabelTile(
                    label: 'Para',
                    iconUrl: icons['BRL']!,
                    title: 'BRL',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 5) Campos de entrada de valor
            Row(
              children: isBuy
                  ? [
                Expanded(
                  child: TextField(
                    controller: brlController,
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                    decoration:
                    const InputDecoration(labelText: 'Valor em BRL'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: cryptoController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Quantidade em $selectedCrypto',
                    ),
                  ),
                ),
              ]
                  : [
                Expanded(
                  child: TextField(
                    controller: cryptoController,
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Quantidade em $selectedCrypto',
                    ),
                    onChanged: (_) => _updateConversion(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: brlController,
                    readOnly: true,
                    decoration:
                    const InputDecoration(labelText: 'Valor em BRL'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 6) Campo para address ou chave PIX
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: isBuy
                    ? 'Endereço da carteira (onde receberá a cripto)'
                    : 'Chave PIX (onde receberá BRL)',
              ),
            ),
            const SizedBox(height: 20),

            // 7) Botão Confirmar
            ElevatedButton(
              onPressed: () {
                final amountCrypto = double.tryParse(
                  cryptoController.text.replaceAll(',', '.'),
                ) ??
                    0.0;
                final amountBrl = double.tryParse(
                  brlController.text.replaceAll(',', '.'),
                ) ??
                    0.0;
                final receiveAddr = addressController.text.trim();

                if (receiveAddr.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, informe o endereço ou PIX.'),
                    ),
                  );
                  return;
                }

                // 1) Gera um quoteId temporário (UUID).
                //    Depois você pode substituir por uma chamada real a /fiat_gateway/quotes.
                final quoteId = const Uuid().v4();

                // 2) Monta os placeholders
                final Map<String, dynamic> emptyAddressMap = {};
                const transferMethod = ''; // se precisar, substitua por "OFFCHAIN" ou "ONCHAIN"
                const chain = '';          // ex: "USDT-TRC20"
                const ipClient = '';       // ex: "127.0.0.1" ou IP real do cliente

                // 3) Navega para KyCPage, passando TODOS os parâmetros necessários
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => KyCPage(
                      foxbitClient: widget.foxbitClient,
                      isBuy: isBuy,
                      symbol: '${selectedCrypto}BRL',
                      amountCrypto: amountCrypto,
                      amountBrl: amountBrl,
                      receiveAddress: receiveAddr,
                      quoteId: quoteId,
                      address: emptyAddressMap,
                      transferMethod: transferMethod,
                      chain: chain,
                      ipClient: ipClient,
                    ),
                  ),
                );
              },
              child: const Text("Confirmar"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelTile({
    required String label,
    required String iconUrl,
    required String title,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Image.network(
                iconUrl,
                width: 24,
                height: 24,
                errorBuilder: (_, __, ___) =>
                const SizedBox(width: 24, height: 24),
              ),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }
}