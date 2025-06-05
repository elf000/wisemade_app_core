import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:wisemade_app_core/infrastructure/wisemade_api.dart';
import 'package:wisemade_app_core/widgets/shared/appbar.dart';

import '../usecases/auth_callback.dart';

class SignupPage extends StatefulWidget {
  final String email;

  const SignupPage({
    Key? key,
    required this.email
  }) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();

  Map? _errors;
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isPasswordConfirmationVisible = false;

  void _handleAuth() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final Map<String, String> auth = await WisemadeApi(context).signUp(
          {
            'registration[email]' : widget.email,
            'registration[password]' : passwordController.text,
            'registration[password_confirmation]' : passwordConfirmationController.text,
            'registration[name]' : nameController.text
          }
      );

      setState(() {
        _isLoading = false;
      });

      if(!mounted) return;
      var session = SessionManager();
      session.set('seenPerformanceReportAt', DateTime.now());
      AuthCallback(context).run(auth);
    } on Map catch (e) {
      _errors = e;
      _formKey.currentState?.validate();
    }
  }


  @override
  Widget build(BuildContext context) {
    final titleText = FlutterI18n.translate(context, 'auth.signup');
    final nameText = FlutterI18n.translate(context, 'auth.fields.name');
    final passwordText = FlutterI18n.translate(context, 'auth.fields.password');
    final passwordConfirmation = FlutterI18n.translate(context, 'auth.fields.password_confirmation');
    final buttonText = FlutterI18n.translate(context, 'shared.continue');

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const CustomAppBar(
        withLogo: true,
        center: true,
        preferredSize: Size.fromHeight(50),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  child: TextFormField(
                      controller: nameController,
                      autocorrect: false,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                        border: const OutlineInputBorder(),
                        labelText: nameText,
                      ),
                      validator: (value) {
                        if(_errors?['name'] != null) return _errors?['name'][0];
                      },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: TextFormField(
                      obscureText: !_isPasswordVisible,
                      controller: passwordController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.visiblePassword,
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
                    validator: (value) {
                      if(_errors?['password'] != null) return _errors?['password'][0];
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: TextFormField(
                      obscureText: !_isPasswordConfirmationVisible,
                      controller: passwordConfirmationController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                        border: const OutlineInputBorder(),
                        labelText: passwordConfirmation,
                        suffixIcon: IconButton(
                            padding: const EdgeInsets.only(right: 10),
                            color: Colors.white,
                            icon: Icon(_isPasswordConfirmationVisible ? Icons.visibility_off : Icons.visibility),
                            iconSize: 32.0,
                            onPressed: () {
                              setState(() {
                                _isPasswordConfirmationVisible = !_isPasswordConfirmationVisible;
                              });
                            }
                        )
                      ),
                      validator: (value) {
                        if (value != '' && value != passwordController.text) return 'A senha e a confirmação da senha devem ser iguais';
                        if(_errors?['password_confirmation'] != null) return _errors?['password_confirmation'][0];
                      },
                      onFieldSubmitted: (_) => {
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
                      child: _isLoading
                        ? const CircularProgressIndicator()
                        : Text(
                            buttonText,
                            style: TextStyle(color: Theme.of(context).primaryColor),
                          ),
                    )
                )
              ],
            ),
          )
        )
      )
    );
  }
}
