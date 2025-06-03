import 'package:flutter/material.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';
import 'package:wisemade_app_core/infrastructure/wisemade_api.dart';
import 'package:wisemade_app_core/widgets/shared/walletconnect_button.dart';

import '../usecases/auth_callback.dart';


class WalletConnectSignInButton extends StatefulWidget {
  const WalletConnectSignInButton({super.key});

  @override
  State<WalletConnectSignInButton> createState() => _WalletConnectSignInButtonState();

}


class _WalletConnectSignInButtonState extends State<WalletConnectSignInButton> {
  void _handleSignIn(IWeb3App client, SessionData session, String address) async {
    final Map<String, String> auth = await WisemadeApi(context).signInWithMetamask(client, session, address);

    if(!mounted) return;
    await AuthCallback(context).run(auth);
  }

  @override
  Widget build(BuildContext context) {
    return WalletConnectButton(variant: 'dark', onSigned: _handleSignIn);
  }
}