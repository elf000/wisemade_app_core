import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:wisemade_app_core/main.dart';
import 'package:wisemade_app_core/pages/setup.dart';

import '../app_state.dart';
import 'intro.dart';

abstract class AuthenticatedPage extends StatefulWidget {
  const AuthenticatedPage({super.key});
}

abstract class AuthenticatedPageState<T extends StatefulWidget> extends State<T> {
  late Future<bool> authHandled;

  @override
  void initState() {
    super.initState();

    authHandled = handleAuth();
  }

  Future<bool> handleAuth() async {
    AppState appState = Provider.of<AppState>(context, listen: false);
    var session = SessionManager();

    if(!await session.containsKey('uid')) {
      if(!mounted) return false;
      PersistentNavBarNavigator.pushNewScreen(
        context!,
        screen: const IntroPage(),
        withNavBar: false,
      );
      return false;
    }

    appState.getCurrentUser(callback: () {
      if(appState.currentUser != null) {
        mixpanel.identify(appState.currentUser!.id.toString());
        mixpanel.registerSuperProperties({ '\$email': appState.currentUser!.email, '\$name': appState.currentUser!.name });

        mixpanel.getPeople().set('\$name', appState.currentUser!.name);
        mixpanel.getPeople().set('\$email', appState.currentUser!.email);

        if(appState.currentUser?.metadata?['riskLevel'] == null) {
          PersistentNavBarNavigator.pushNewScreen(
            context!,
            screen: const SetupPage(),
            withNavBar: false,
          );
        }
      }
    });

    return true;
  }

  Widget render(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: authHandled,
      builder: (context, snapshot) {
        if(snapshot.hasData && snapshot.data! == true) {
          return render(context);
        }

        return const Center(
            child: CircularProgressIndicator()
        );
      }
    );
  }
}
