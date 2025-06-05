// lib/pages/confirm.dart

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wisemade_app_core/infrastructure/foxbit_client.dart';
import 'package:wisemade_app_core/models/order.dart'; // Aqui está OrderResponse

class ConfirmationPage extends StatefulWidget {
  final FoxbitClient foxbitClient;
  final bool isBuy;
  final String symbol;
  final double amountCrypto;
  final double amountBrl;
  final String subMemberId;

  // Parâmetros necessários para `createOrder`
  final String taxIdNumber;
  final String name;
  final String phone;
  final String birthDate;      // Formato "YYYY-MM-DD"
  final String paymentMethod;  // Ex.: "PIX"
  final String receiveAccount; // Wallet address ou Chave PIX
  final String quoteId;
  final Map<String, dynamic> address;
  final String transferMethod; // Ex.: "OFFCHAIN"
  final String chain;          // Ex.: "USDT-TRC20"
  final String ipClient;       // Ex.: "127.0.0.1"

  const ConfirmationPage({
    super.key,
    required this.foxbitClient,
    required this.isBuy,
    required this.symbol,
    required this.amountCrypto,
    required this.amountBrl,
    required this.subMemberId,
    required this.taxIdNumber,
    required this.name,
    required this.phone,
    required this.birthDate,
    required this.paymentMethod,
    required this.receiveAccount,
    required this.quoteId,
    required this.address,
    required this.transferMethod,
    required this.chain,
    required this.ipClient,
  });

  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  bool _isLoading = false;

  String? pixPayload;    // Será preenchido se for compra (PIX)
  String? pixKey;        // Chave Pix (retornada na compra)
  String? walletAddress; // Endereço de carteira (no caso de venda)
  String orderId = '';   // O ID retornado pela API

  @override
  void initState() {
    super.initState();
    _createOrder();
  }

  Future<void> _createOrder() async {
    setState(() => _isLoading = true);

    try {
      final OrderResponse order = await widget.foxbitClient.createOrder(
        isBuy:          widget.isBuy,
        subMemberSn:    widget.subMemberId,
        taxIdNumber:    widget.taxIdNumber,
        name:           widget.name,
        phone:          widget.phone,
        birthDate:      widget.birthDate,
        paymentMethod:  widget.paymentMethod,
        receiveAccount: widget.receiveAccount,
        quoteId:        widget.quoteId,
        address:        widget.address,
        transferMethod: widget.transferMethod,
        chain:          widget.chain,
        ipClient:       widget.ipClient,
      );

      if (!mounted) return;
      setState(() {
        orderId = order.orderId;
        if (widget.isBuy) {
          pixPayload = order.pixPayload;
          pixKey     = order.pixKey;
        } else {
          walletAddress = order.walletAddress;
        }
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao criar ordem: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _confirmTransaction() {
    // Volta até a primeira tela (home) no fluxo simplificado
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirmação"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Resumo da operação',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ordem ID: $orderId'),
                  const SizedBox(height: 8),
                  Text('Tipo: ${widget.isBuy ? 'Compra' : 'Venda'}'),
                  const SizedBox(height: 8),
                  Text(
                    widget.isBuy
                        ? 'Valor (BRL): R\$ ${widget.amountBrl.toStringAsFixed(2)}'
                        : 'Valor (Crypto): ${widget.amountCrypto.toStringAsFixed(8)}',
                  ),
                  const SizedBox(height: 8),

                  // Se for compra → exibe QR de PIX
                  if (widget.isBuy) ...[
                    Text('Chave Pix: ${pixKey ?? '-'}'),
                    const SizedBox(height: 8),
                    if (pixPayload != null) ...[
                      Center(
                        child: QrImageView(
                          data: pixPayload!,
                          size: 200.0,
                        ),
                      ),
                    ],
                  ] else ...[
                    // Se for venda → exibe wallet QR
                    Text('Endereço carteira: ${walletAddress ?? '-'}'),
                    const SizedBox(height: 16),
                    if (walletAddress != null) ...[
                      Center(
                        child: QrImageView(
                          data: walletAddress!,
                          size: 200.0,
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _confirmTransaction,
              child: const Text('Confirmar e Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}