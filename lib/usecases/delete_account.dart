import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:wisemade_app_core/infrastructure/wisemade_api.dart';
import 'package:wisemade_app_core/pages/setup.dart';

import '../app_state.dart';
import '../models/user.dart';
import '../pages/app.dart';
import '../pages/intro.dart';

class DeleteAccount {
  final BuildContext context;

  DeleteAccount(this.context);

  Future run() async {
    AppState appState = Provider.of<AppState>(context, listen: false);

    var session = SessionManager();
    await WisemadeApi(context).deleteAccount();
    await appState.resetAppState();
    await session.destroy();

    PersistentNavBarNavigator.pushNewScreen(
      context!,
      screen: const IntroPage(),
      withNavBar: false,
    );
  }
}