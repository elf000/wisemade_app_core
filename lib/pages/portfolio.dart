import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:wisemade_app_core/main.dart';
import 'package:wisemade_app_core/pages/authenticated_page.dart';
import 'package:wisemade_app_core/widgets/shared/appbar.dart';

import '../app_state.dart';
import '../widgets/my_accounts/portfolio.dart';

class PortfolioPage extends AuthenticatedPage {
  const PortfolioPage({super.key});

  @override
  AuthenticatedPageState<PortfolioPage> createState() => _CockpitPageState();
}

class _CockpitPageState extends AuthenticatedPageState<PortfolioPage> {

  @override
  void initState() {
    super.initState();

    getData();
  }

  void getData() {
    AppState appState = Provider.of<AppState>(context, listen: false);

    Future.wait([
      appState.getPortfolioSnapshot(),
      appState.getAssetHolders(),
    ]);

    appState.shouldFetchCockpitData = false;
  }

  @override
  Widget render(BuildContext context) {
    mixpanel.track('Viewed Screen - Portfolio');
    final titleText = FlutterI18n.translate(context, 'navbar.portfolio');

    return DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: CustomAppBar(
            withAvatar: true,
            title: titleText,
            preferredSize: const Size.fromHeight(70),
            withSearch: true,
          ),
          body: const Portfolio(),
          )
    );
  }
}
