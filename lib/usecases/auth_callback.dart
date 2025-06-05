// lib/usecases/auth_callback.dart

import 'dart:io';  // só aqui porque usamos Platform.isIOS
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../models/user.dart';
import '../pages/app.dart';
import '../pages/fiat_setup.dart';

class AuthCallback {
  final BuildContext context;

  AuthCallback(this.context);

  Future<void> run(Map<String, String> auth) async {
    final navigator = Navigator.of(context);
    final appState = Provider.of<AppState>(context, listen: false);
    final session = SessionManager();

    // 1. Solicitar permissão de rastreamento somente em iOS 14+:
    if (Platform.isIOS) {
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;
      if (status != TrackingStatus.authorized) {
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
    }

    // 2. Armazenar dados de autenticação na sessão:
    await Future.wait([
      session.set('isLoggedIn', true),
      session.set('uid',         auth['uid']),
      session.set('access-token',auth['access-token']),
      session.set('expiry',      auth['expiry']),
      session.set('client',      auth['client']),
    ]);

    // 3. Resetar estado global e obter usuário atual:
    await appState.resetAppState();
    User? user = await appState.getCurrentUser();

    // 4. Navegar de acordo com metadados do usuário:
    if (user?.metadata != null) {
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AppPage()),
            (route) => false,
      );
    } else {
      if (!context.mounted) return;
      PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: const FiatSetupPage(),
        withNavBar: false,
      );
    }
  }
}