import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:wisemade_app_core/pages/setup.dart';

import '../app_state.dart';


class FiatSetupPage extends StatefulWidget {
  const FiatSetupPage({super.key});

  @override
  State<FiatSetupPage> createState() => _FiatSetupPageState();
}

class _FiatSetupPageState extends State<FiatSetupPage> {

  String _selectedFiat = 'usd';

  @override
  Widget build(BuildContext context) {
    final titleText = FlutterI18n.translate(context, 'fiat_setup.subtitle');
    final brlText = FlutterI18n.translate(context, 'fiat_setup.currencies.brl');
    final usdText = FlutterI18n.translate(context, 'fiat_setup.currencies.usd');
    final eurText = FlutterI18n.translate(context, 'fiat_setup.currencies.eur');

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Container(
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  child: Image.asset('images/owl-with-pencil-and-paper.png', width: 200),
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      titleText,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    )
                  )
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: DropdownMenu(
                    width: MediaQuery.of(context).size.width * 0.9,
                    initialSelection: _selectedFiat,
                    menuStyle: MenuStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.primaryContainer),
                      elevation: MaterialStateProperty.all<double>(0),
                    ),
                    onSelected: (value) {
                      setState(() {
                        _selectedFiat = value!;
                      });
                    },
                    dropdownMenuEntries: [
                      DropdownMenuEntry(value: 'usd', label: usdText),
                      DropdownMenuEntry(value: 'brl', label: brlText),
                      DropdownMenuEntry(value: 'eur', label: eurText),
                    ]
                  )
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: ElevatedButton(
                    onPressed: () async {
                      AppState appState = Provider.of<AppState>(context, listen: false);
                      await appState.setupFiat(_selectedFiat);

                      if(!mounted) return;
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const SetupPage()),
                              (route) => false
                      );
                    },
                    child: const Text('Continue')
                  )
                )
              ]
            )
          )
      )
    );
  }
}