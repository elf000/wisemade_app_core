import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:wisemade_app_core/infrastructure/wisemade_api.dart';
import 'package:wisemade_app_core/pages/login.dart';
import 'package:wisemade_app_core/pages/signup.dart';
import 'package:wisemade_app_core/widgets/shared/appbar.dart';
import 'package:wisemade_app_core/widgets/shared/apple_signin_button.dart';
import 'package:wisemade_app_core/widgets/shared/google_signin_button.dart';
import 'package:wisemade_app_core/widgets/walletconnect_signin_button.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  void _handleAuth() async {
    try {
      final bool emailExists = await WisemadeApi(context).doesEmailExist(emailController.text);

      if (!mounted) return;
      if (emailExists) {
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: LoginPage(email: emailController.text),
          withNavBar: false,
        );
      } else {
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: SignupPage(email: emailController.text),
          withNavBar: false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final orText = FlutterI18n.translate(context, 'shared.or');
    final emailErrorText = FlutterI18n.translate(context, 'auth.errors.email');
    final buttonText = FlutterI18n.translate(context, 'auth.button');
    final termsPart1Text = FlutterI18n.translate(context, 'auth.terms.part_1');
    final termsPart2Text = FlutterI18n.translate(context, 'auth.terms.part_2');
    final termsPart3Text = FlutterI18n.translate(context, 'auth.terms.part_3');
    final termsPart4Text = FlutterI18n.translate(context, 'auth.terms.part_4');

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const CustomAppBar(
        withLogo: true,
        center: true,
        preferredSize: Size.fromHeight(50),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 50),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  children: [
                    const WalletConnectSignInButton(),
                    const SizedBox(height: 10),
                    const GoogleSignInButton(),
                    const SizedBox(height: 10),
                    Platform.isIOS ? const AppleSignInButton() : const SizedBox(),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      // Aqui substituímos caption por bodySmall:
                      child: Text(
                        orText,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    const Expanded(
                      child: Divider(color: Colors.white),
                    ),
                  ],
                ),
              ),
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: TextFormField(
                    controller: emailController,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      border: OutlineInputBorder(),
                      labelText: 'E-mail',
                    ),
                    validator: (value) =>
                    EmailValidator.validate(value ?? '') ? null : emailErrorText,
                    onFieldSubmitted: (_) => _handleAuth(),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: ElevatedButton(
                  onPressed: _handleAuth,
                  child: Text(
                    buttonText,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodySmall,
                    children: [
                      TextSpan(text: termsPart1Text),
                      WidgetSpan(
                        child: InkWell(
                          onTap: () {
                            launchUrlString('https://wisemade.io/terms-and-conditions');
                          },
                          child: Text(
                            termsPart2Text,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(decoration: TextDecoration.underline),
                          ),
                        ),
                      ),
                      TextSpan(text: termsPart3Text),
                      WidgetSpan(
                        child: InkWell(
                          onTap: () {
                            launchUrlString('https://wisemade.io/privacy-policy');
                          },
                          child: Text(
                            termsPart4Text,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(decoration: TextDecoration.underline),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}