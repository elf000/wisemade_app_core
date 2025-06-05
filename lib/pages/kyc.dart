// lib/pages/kyc.dart

import 'package:flutter/material.dart';
import 'package:wisemade_app_core/infrastructure/foxbit_client.dart';
import 'package:wisemade_app_core/pages/confirm.dart';

class KyCPage extends StatefulWidget {
  final FoxbitClient foxbitClient;
  final bool isBuy;
  final String symbol;
  final double amountCrypto;
  final double amountBrl;
  final String receiveAddress;
  final String quoteId;
  final Map<String, dynamic> address;
  final String transferMethod;
  final String chain;
  final String ipClient;

  const KyCPage({
    super.key,
    required this.foxbitClient,
    required this.isBuy,
    required this.symbol,
    required this.amountCrypto,
    required this.amountBrl,
    required this.receiveAddress,
    required this.quoteId,
    required this.address,
    required this.transferMethod,
    required this.chain,
    required this.ipClient,
  });

  @override
  State<KyCPage> createState() => _KyCPageState();
}

class _KyCPageState extends State<KyCPage> {
  final _nameController      = TextEditingController();
  final _cpfController       = TextEditingController();
  final _emailController     = TextEditingController();
  final _phoneController     = TextEditingController();
  final _birthDateController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitKYC() async {
    if (_nameController.text.isEmpty ||
        _cpfController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _birthDateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos obrigatórios')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1) Cria o sub‐member (KYC)
      final subMember = await widget.foxbitClient.createSubMember(
        name: _nameController.text.trim(),
        cpf: _cpfController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        birthDate: _birthDateController.text.trim(),
      );

      if (!mounted) return;

      // 2) Navega para ConfirmationPage, passando TODOS os dados necessários
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ConfirmationPage(
            foxbitClient: widget.foxbitClient,
            isBuy: widget.isBuy,
            symbol: widget.symbol,
            amountCrypto: widget.amountCrypto,
            amountBrl: widget.amountBrl,
            subMemberId: subMember.sn,

            taxIdNumber: _cpfController.text.trim(),
            name: _nameController.text.trim(),
            phone: _phoneController.text.trim(),
            birthDate: _birthDateController.text.trim(),
            paymentMethod: 'PIX',
            receiveAccount: widget.receiveAddress,
            quoteId: widget.quoteId,           // repassado de trade.dart
            address: widget.address,           // repassado de trade.dart
            transferMethod: widget.transferMethod,
            chain: widget.chain,
            ipClient: widget.ipClient,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao criar KYC: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cpfController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("KYC"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome completo'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _cpfController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'CPF (apenas números)'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Telefone (55119XXXXXXXX)'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _birthDateController,
              keyboardType: TextInputType.datetime,
              decoration: const InputDecoration(labelText: 'Data de nascimento (YYYY-MM-DD)'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitKYC,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.black)
                  : const Text('Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}
