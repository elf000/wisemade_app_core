import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:wisemade_app_core/infrastructure/wisemade_api.dart';
import 'package:wisemade_app_core/widgets/shared/appbar.dart';

import '../usecases/auth_callback.dart';

class LoginPage extends StatefulWidget {
  final String email;

  const LoginPage({
    Key? key,
    required this.email
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  void _handleAuth() async {
    try {
      final Map<String, String> auth = await WisemadeApi(context).signIn(
          { 'email' : widget.email, 'password' : passwordController.text }
      );

      if(!mounted) return;
      AuthCallback(context).run(auth);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final titleText = FlutterI18n.translate(context, 'auth.title');
    final passwordText = FlutterI18n.translate(context, 'auth.fields.password');
    final buttonText = FlutterI18n.translate(context, 'shared.continue');

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
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
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(titleText, style: Theme.of(context).textTheme.headlineMedium)
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: TextField(
                  obscureText: !_isPasswordVisible,
                  controller: passwordController,
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                    border: const OutlineInputBorder(),
                    labelText: passwordText,
                    suffixIcon: IconButton(
                      padding: const EdgeInsets.only(right: 10),
                      color: Colors.white,
                      icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                      iconSize: 32.0,
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      }
                    )
                  ),
                  onSubmitted: (_) => {
                    _handleAuth()
                  }
                ),
              ),
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: ElevatedButton(
                      onPressed: () => {
                        _handleAuth()
                      },
                      child: Text(
                        buttonText,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      )
                  )
              )
            ],
          ),
        )
      )
    );
  }
}
