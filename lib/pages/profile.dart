import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:wisemade_app_core/pages/settings.dart';
import 'package:wisemade_app_core/pages/webview_screen.dart';
import 'package:wisemade_app_core/widgets/shared/nft_avatar.dart';

import '../app_state.dart';
import '../main.dart';
import '../widgets/shared/appbar.dart';
import '../widgets/shared/list_item.dart';
import 'authenticated_page.dart';
import 'intro.dart';

class ProfilePage extends AuthenticatedPage {
  const ProfilePage({super.key});

  @override
  AuthenticatedPageState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends AuthenticatedPageState<ProfilePage> {

  @override
  void initState() {
    super.initState();
    getData();
  }


  Future getData() async {
    AppState appState = Provider.of<AppState>(context, listen: false);

    await Future.wait([
      appState.getCurrentUser(),
      appState.getAvatarNFT(),
    ]);
  }

  @override
  Widget render(BuildContext context) {
    mixpanel.track('Viewed Screen - Profile');

    final titleText = FlutterI18n.translate(context, 'navbar.profile');
    final nftWebviewTitle = FlutterI18n.translate(context, 'profile.nft_webview_title');
    final nftCTAText = FlutterI18n.translate(context, 'profile.nft_cta');
    final menuTitleText = FlutterI18n.translate(context, 'profile.menu.title');
    final termsAndConditionsText = FlutterI18n.translate(context, 'profile.menu.terms_and_conditions.title');
    final termsAndConditionsWebviewTitleText = FlutterI18n.translate(context, 'profile.menu.terms_and_conditions.webview_title');
    final settingsText = FlutterI18n.translate(context, 'profile.menu.settings');
    final logoutText = FlutterI18n.translate(context, 'profile.menu.logout');

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: CustomAppBar(title: titleText, preferredSize: const Size.fromHeight(70), withAvatar: false, withSearch: false),
      body: Consumer<AppState>(
        builder: (context, state, child) {
          return SafeArea(
            child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: ListView(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.fromLTRB(32, 20, 32, 0),
                        child: const NFTAvatar(size: double.infinity, borderRadius: 25)
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(state.currentUser?.name ?? '', style: Theme.of(context).textTheme.headlineSmall)
                      ),
                      state.currentUser?.metamaskPublicAddress == null && state.avatarMetadata?['image'] != null ?
                      ListItem(
                        orientation: 'vertical',
                        onTap: () {
                          mixpanel.track('Clicked on [Withdraw NFT]');

                          PersistentNavBarNavigator.pushNewScreen(
                            context,
                            screen: WebviewScreen(url: 'https://blog.wisemade.io/tutorial-nft', title: nftWebviewTitle),
                            withNavBar: false,
                          );
                        },
                        children: [
                          Text(
                            nftCTAText,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ]
                      ) : const SizedBox(),
                      Container(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(menuTitleText, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey))
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 16),
                        child: Column(
                          children: [
                            MenuItem(
                                icon: Icons.info_outline,
                                text: termsAndConditionsText,
                                onTap: () async {

                                  PersistentNavBarNavigator.pushNewScreen(
                                    context,
                                    screen: WebviewScreen(
                                        title: termsAndConditionsWebviewTitleText,
                                        url: 'https://wisemade.io/terms-and-conditions'
                                    ),
                                    withNavBar: false,
                                  );
                                }
                            ),
                            MenuItem(
                                icon: Icons.settings,
                                text: settingsText,
                                onTap: () async {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => const SettingsPage())
                                  );
                                }
                            ),
                            MenuItem(
                                icon: Icons.power_settings_new,
                                text: logoutText,
                                onTap: () async {
                                  final session = SessionManager();
                                  await session.destroy();

                                  if(!mounted) return;
                                  PersistentNavBarNavigator.pushNewScreen(
                                    context,
                                    screen: const IntroPage(),
                                    withNavBar: false,
                                  );
                                }
                            )
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

  const MenuItem({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap
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
                child: Icon(icon),
              ),
              Text(text, style: Theme.of(context).textTheme.titleMedium)
            ]
          )
        )
    );
  }
}
