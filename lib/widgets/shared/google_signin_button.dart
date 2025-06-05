import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../infrastructure/wisemade_api.dart';
import '../../usecases/auth_callback.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({super.key});

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isLoading = false;

  void _signInWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: <String>[
        'profile',
        'email',
      ],
    );

    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Solicita ao Google que abra a tela de login.
      GoogleSignInAccount? response = await googleSignIn.signIn();

      // 2. Se o usuário cancelar, `response` será null. Basta interromper aqui.
      if (response == null) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // 3. Neste ponto, `response` é não-nulo, então podemos chamar a API.
      final Map<String, String> auth =
      await WisemadeApi(context).signInWithGoogle(response);

      if (!mounted) return;
      AuthCallback(context).run(auth);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      // 4. Em caso de erro, apenas desliga o indicador de loading e opcionalmente trate o erro.
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      // Você pode logar ou mostrar uma mensagem de erro aqui, se quiser:
      // debugPrint('Erro ao fazer login via Google: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final labelText = FlutterI18n.translate(context, 'auth.google');

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: OutlinedButton(
        onPressed: _signInWithGoogle,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            Theme.of(context).colorScheme.surface,
          ),
          padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.all(20),
          ),
        ),
        child: _isLoading
            ? const CircularProgressIndicator()
            : Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('images/google-signin-icon.png', height: 32),
            Text(
              labelText,
              style: TextStyle(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}