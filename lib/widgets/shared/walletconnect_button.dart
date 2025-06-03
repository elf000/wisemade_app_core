import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';


class WalletConnectButton extends StatefulWidget {
  final String variant;
  final Function onSigned;

  const WalletConnectButton({
    super.key,
    required this.onSigned,
    required this.variant
  });

  @override
  State<WalletConnectButton> createState() => _WalletConnectButtonState();

}


class _WalletConnectButtonState extends State<WalletConnectButton> {
  late W3MService _w3mService;
  bool _signInHandled = false;

  @override
  void initState() {
    _initWeb3Modal();
    super.initState();
  }

  void _initWeb3Modal () async {
    _w3mService = W3MService(
      projectId: 'ab98ee61e0eeb236666b4389336aa967',
      metadata: const PairingMetadata(
          name: 'Wisemade',
          description: 'Wisemade',
          url: 'https://wisemade.io',
          icons: ['https://wisemade.io/mstile-150x150.png'],
          redirect: Redirect(
            native: 'wisemade://',
            universal: 'https://wisemade.io',
          )
      ),
    );

    _w3mService.addListener(_signMessage);
    await _w3mService.init();


  }

  void _signMessage() async {
    final session = _w3mService.session;
    // Verifica se está conectado, se existe session e se há um address válido
    if (_w3mService.isConnected && session != null && session.address != null && !_signInHandled) {
      setState(() {
        _signInHandled = true;
      });

      // Passa web3App, session e session.address para o onSigned
      await widget.onSigned(
        _w3mService.web3App!,
        session,
        session.address!,
      );
      _w3mService.disconnect();
    }
  }

  @override
  Widget build(BuildContext context) {
    String image = widget.variant == 'dark' ? 'images/walletconnect-icon.png' : 'images/walletconnect-icon-dark.png';
    Color background = widget.variant == 'dark' ? Theme.of(context).cardColor : Colors.white;
    Color textColor = widget.variant == 'dark' ? Colors.white : Theme.of(context).colorScheme.primary;

    final buttonText = FlutterI18n.translate(context, 'auth.walletconnect');

    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
            onPressed: () {
              _w3mService.openModal(context);
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: background,
              side: BorderSide(color: Theme.of(context).cardColor),
              padding: const EdgeInsets.all(20),
              elevation: 0
            ),

            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(image, height: 32),
                  Text(
                    buttonText,
                    style: TextStyle(color: textColor),
                  )
                ]
            )
        )
    );
  }
}