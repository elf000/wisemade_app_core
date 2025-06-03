import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../infrastructure/wisemade_api.dart';
import '../../usecases/auth_callback.dart';

class AppleSignInButton extends StatefulWidget {
  const AppleSignInButton({super.key});

  @override
  State<AppleSignInButton> createState() => _AppleSignInButtonState();

}


class _AppleSignInButtonState extends State<AppleSignInButton> {
  void _signInWithApple() async {
    final AuthorizationCredentialAppleID credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    if(!mounted) return;
    final Map<String, String> auth = await WisemadeApi(context).signInWithApple(credential);

    if(!mounted) return;
    AuthCallback(context).run(auth);
  }

  @override
  Widget build(BuildContext context) {
    final labelText = FlutterI18n.translate(context, 'auth.apple');

    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: OutlinedButton(
            onPressed: () => {
              _signInWithApple()
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.background),
              padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(20)),
            ),

            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    width: 32 * (25 / 31),
                    height: 32,
                    child: CustomPaint(
                      painter: AppleLogoPainter(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    labelText,
                    style: TextStyle(color: Theme.of(context).colorScheme.outline),
                  )
                ]
            )
        )
    );
  }
}