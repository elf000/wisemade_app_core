import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:wisemade_app_core/widgets/shared/supported_networks.dart';
import 'package:wisemade_app_core/widgets/shared/walletconnect_add_wallet_button.dart';

import '../../app_state.dart';

class AddWallet extends StatefulWidget {
  const AddWallet({
    Key? key,
  }) : super(key: key);

  @override
  State<AddWallet> createState() => _AddWalletState();
}

class _AddWalletState extends State<AddWallet> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final addressController = TextEditingController();
  final MobileScannerController qrViewController = MobileScannerController(
    torchEnabled: false,
    autoStart: false,
    detectionSpeed: DetectionSpeed.normal,
    detectionTimeoutMs: 250,
  );

  bool isStarted = false;

  // Inicia o scanner de QR
  void _startQRScanner() async {
    try {
      await qrViewController.start();
      // Pequeno delay para ajustar zoom
      Timer(const Duration(milliseconds: 500), () {
        qrViewController.setZoomScale(1);
        setState(() {
          isStarted = true;
        });
      });
    } on Exception catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong! $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    addressController.dispose();
    qrViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context, listen: true);
    appState.context = context;

    final scanWindow = Rect.fromCenter(
      center: MediaQuery.of(context).size.center(Offset.zero),
      width: 200,
      height: 200,
    );

    final orText = FlutterI18n.translate(context, 'shared.or');
    final walletAddressText =
    FlutterI18n.translate(context, 'add_wallet.wallet_address');
    final buttonText = FlutterI18n.translate(context, 'add_wallet.button');

    return Stack(children: [
      Container(
        margin: const EdgeInsets.only(top: 50),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const WalletConnectAddWalletButton(),

              // Divisor com “ou”
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: Divider(),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        orText,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    const Expanded(
                      child: Divider(),
                    ),
                  ],
                ),
              ),

              // Campo de texto para digitar endereço + ícone de QR
              TextFormField(
                controller: addressController,
                autocorrect: false,
                enableSuggestions: false,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: walletAddressText,
                  suffixIcon: addressController.value.text.isEmpty
                      ? IconButton(
                    color: Colors.white,
                    icon: const Icon(Icons.qr_code_scanner_rounded),
                    iconSize: 32.0,
                    onPressed: _startQRScanner,
                  )
                      : null,
                ),
                onChanged: (String value) {
                  setState(() {});
                },
              ),

              // Botão “Adicionar carteira”
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: ElevatedButton(
                  onPressed: addressController.text.isNotEmpty &&
                      !appState.addWalletLoading
                      ? () {
                    appState.addWallet({
                      'address': addressController.text.trim(),
                    });
                  }
                      : null,
                  child: appState.addWalletLoading == true
                      ? const CircularProgressIndicator()
                      : Text(buttonText),
                ),
              ),

              const SupportedNetworks(),
            ],
          ),
        ),
      ),

      // Se estiver escaneando, mostra o MobileScanner atrás
      if (isStarted)
        MobileScanner(
          scanWindow: scanWindow,
          controller: qrViewController,
          errorBuilder: (BuildContext context, MobileScannerException error) {
            return ScannerErrorWidget(error: error);
          },
          fit: BoxFit.fitHeight,
          onDetect: (BarcodeCapture capture) {
            // Para imediatamente ao detectar algo
            qrViewController.stop();

            if (capture.barcodes.isNotEmpty) {
              final rawValue = capture.barcodes.first.rawValue;
              if (rawValue != null) {
                final texto = rawValue.split(':').last;
                setState(() {
                  isStarted = false;
                  addressController.value =
                      TextEditingValue(text: texto);
                });
              }
            }
          },
        ),

      // Sobreposição preta cortando a área de scanner
      if (isStarted)
        CustomPaint(
          painter: ScannerOverlay(scanWindow),
        ),
    ]);
  }
}

class ScannerOverlay extends CustomPainter {
  final Rect scanWindow;

  ScannerOverlay(this.scanWindow);

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Rect.largest);
    final cutoutPath = Path()..addRect(scanWindow);

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout =
    Path.combine(PathOperation.difference, backgroundPath, cutoutPath);
    canvas.drawPath(backgroundWithCutout, backgroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ScannerErrorWidget extends StatelessWidget {
  final MobileScannerException error;

  const ScannerErrorWidget({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String errorMessage;
    switch (error.errorCode) {
      case MobileScannerErrorCode.controllerUninitialized:
        errorMessage = 'Controller not ready.';
        break;
      case MobileScannerErrorCode.permissionDenied:
        errorMessage = 'Permission denied';
        break;
      default:
        errorMessage = 'Generic Error';
        break;
    }

    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Icon(Icons.error, color: Colors.white),
            ),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              error.errorDetails?.message ?? '',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}