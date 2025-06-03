import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';

import '../../app_state.dart';

class GreetingsHeader extends StatefulWidget {
  const GreetingsHeader({
    super.key,
  });

  @override
  State<GreetingsHeader> createState() => _GreetingsHeaderState();
}

class _GreetingsHeaderState extends State<GreetingsHeader> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        String? firstName = appState.currentUser?.name.split(' ')[0];
        final greetingsText = FlutterI18n.translate(context, 'home.greetings', translationParams: { 'name' : '$firstName' });

        if(firstName == null) return const SizedBox();

        return appState.currentUser?.email != null
          ? Text(greetingsText, style: Theme.of(context).textTheme.headlineSmall)
          : Text(appState.currentUser!.name, style: Theme.of(context).textTheme.headlineSmall); // Wallet Address
      }
    );
  }
}