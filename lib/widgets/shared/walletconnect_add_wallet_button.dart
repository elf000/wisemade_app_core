import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';
import 'package:wisemade_app_core/app_state.dart';
import 'package:wisemade_app_core/widgets/shared/walletconnect_button.dart';


class WalletConnectAddWalletButton extends StatefulWidget {
  const WalletConnectAddWalletButton({super.key});

  @override
  State<WalletConnectAddWalletButton> createState() => _WalletConnectAddWalletButtonState();

}


class _WalletConnectAddWalletButtonState extends State<WalletConnectAddWalletButton> {
  void _handleSignIn(IWeb3App client, SessionData session, String address) async {
    AppState appState = Provider.of<AppState>(context, listen: false);
    appState.context = context;

    appState.addWallet({ 'address' : address });
  }

  @override
  Widget build(BuildContext context) {
    return WalletConnectButton(variant: 'light', onSigned: _handleSignIn);
  }
}