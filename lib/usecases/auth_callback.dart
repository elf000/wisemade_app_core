import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:wisemade_app_core/pages/fiat_setup.dart';
import 'package:wisemade_app_core/pages/setup.dart';

import '../app_state.dart';
import '../models/user.dart';
import '../pages/app.dart';

class AuthCallback {
  final BuildContext context;

  AuthCallback(this.context);

  Future run(Map<String, String> auth) async {
    final navigator = Navigator.of(context);
    AppState appState = Provider.of<AppState>(context, listen: false);
    var session = SessionManager();

    if (await AppTrackingTransparency.trackingAuthorizationStatus != TrackingStatus.authorized) {
      final x = await AppTrackingTransparency.trackingAuthorizationStatus;
      await AppTrackingTransparency.requestTrackingAuthorization();
    }

    await Future.wait([
      session.set('isLoggedIn', true),
      session.set('uid', auth['uid']),
      session.set('access-token', auth['access-token']),
      session.set('expiry', auth['expiry']),
      session.set('client', auth['client']),
    ]);
    await appState.resetAppState();
    User? user = await appState.getCurrentUser();

    if(user?.metadata != null) {
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AppPage()), (route) => false
      );
    } else {
      if(!context.mounted) return;
      PersistentNavBarNavigator.pushNewScreen(
        context!,
        screen: const FiatSetupPage(),
        withNavBar: false,
      );
    }
  }
}