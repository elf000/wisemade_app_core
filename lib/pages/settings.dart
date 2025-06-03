import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:wisemade_app_core/usecases/delete_account.dart';

import '../app_state.dart';
import '../main.dart';
import '../widgets/shared/appbar.dart';
import 'authenticated_page.dart';

class SettingsPage extends AuthenticatedPage {
  const SettingsPage({super.key});

  @override
  AuthenticatedPageState<SettingsPage> createState() => _ProfilePageState();
}

class _ProfilePageState extends AuthenticatedPageState<SettingsPage> {

  void _setLanguage(BuildContext context, String? language) async {
    if(language == null) return;

    AppState appState = Provider.of<AppState>(context, listen: false);
    appState.setLocale(language);

    final successText = FlutterI18n.translate(context, 'settings.language.success');

    if(!mounted) return;
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context!).showSnackBar(
      SnackBar(
        content: Text(successText, style: Theme.of(context!).textTheme.bodyMedium?.copyWith(color: Colors.black)),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
      ),
    );
  }

  void _delete(BuildContext context) {
    final titleText = FlutterI18n.translate(context, 'settings.delete_account.title');
    final contentText = FlutterI18n.translate(context, 'settings.delete_account.content');
    final yesText = FlutterI18n.translate(context, 'settings.delete_account.yes');
    final cancelText = FlutterI18n.translate(context, 'settings.delete_account.cancel');

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(titleText),
            content: Text(contentText),
            actions: [
              TextButton(
                  onPressed: () {
                    DeleteAccount(context).run();
                  },
                  child: Text(yesText, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white))),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(cancelText, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)))
            ],
          );
        });
  }

  @override
  Widget render(BuildContext context) {
    mixpanel.track('Viewed Screen - Settings');

    AppState appState = Provider.of<AppState>(context, listen: true);

    final titleText = FlutterI18n.translate(context, 'navbar.settings');
    final languageText = FlutterI18n.translate(context, 'settings.options.language');
    final deleteAccountText = FlutterI18n.translate(context, 'settings.options.delete_account');

    final englishText = FlutterI18n.translate(context, 'settings.language.english');
    final spanishText = FlutterI18n.translate(context, 'settings.language.spanish');
    final portugueseText = FlutterI18n.translate(context, 'settings.language.portuguese');

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: CustomAppBar(title: titleText, preferredSize: const Size.fromHeight(50)),
      body: Consumer<AppState>(
        builder: (context, state, child) {
          return SafeArea(
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(top: 16),
                        child: Column(
                          children: [
                            MenuItem(
                                icon: Icons.language,
                                text: languageText,
                                onTap: () async {
                                  showModalBottomSheet(context: context, builder: (context) {
                                    return Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 100),
                                      child: DropdownMenu(
                                        width: MediaQuery.of(context).size.width * 0.9,
                                        initialSelection: appState.currentLocale,
                                        menuStyle: MenuStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.primaryContainer),
                                        ),
                                        onSelected: (value) => _setLanguage(context, value),
                                        dropdownMenuEntries: [
                                          DropdownMenuEntry(value: 'en', label: englishText),
                                          DropdownMenuEntry(value: 'pt', label: portugueseText),
                                          DropdownMenuEntry(value: 'es', label: spanishText),
                                        ]
                                      )
                                    );
                                  });
                                }
                            ),
                            MenuItem(
                                icon: Icons.delete,
                                text: deleteAccountText,
                                color: Colors.red,
                                onTap: () async {
                                  _delete(context);
                                }
                            ),
                          ]
                        )
                      )
                    ]
                )
            )
          );
        }
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onTap;
  final Color? color;

  const MenuItem({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onTap(),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.only(right: 32),
                child: Icon(icon, color: color ?? Colors.white),
              ),
              Text(text, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color ?? Colors.white))
            ]
          )
        )
    );
  }
}
