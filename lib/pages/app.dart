import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';
import 'package:wisemade_app_core/pages/add_connection.dart';
import 'package:wisemade_app_core/pages/portfolio.dart';
import 'package:wisemade_app_core/pages/home.dart';
import 'package:wisemade_app_core/pages/explore.dart';

import '../app_state.dart';
import 'authenticated_page.dart';
import 'discover.dart';

class AppPage extends AuthenticatedPage {
  const AppPage({super.key});

  @override
  AuthenticatedPageState<AppPage> createState() => _AppPageState();
}

class _AppPageState extends AuthenticatedPageState<AppPage> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    _controller = appState.tabController;
    _controller.jumpToTab(0);
  }

  List<Widget> _buildScreens() {
    return [
      const DashboardPage(),
      const PortfolioPage(),
      const AddResource(),
      const DiscoverPage(),
      const ExplorePage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    final homeText = FlutterI18n.translate(context, 'navbar.home');
    final portfolioText = FlutterI18n.translate(context, 'navbar.portfolio');
    final connectText = FlutterI18n.translate(context, 'navbar.connect');
    final discoverText = FlutterI18n.translate(context, 'navbar.discover');
    final exploreText = FlutterI18n.translate(context, 'navbar.explore');

    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: homeText,
        activeColorPrimary: Theme.of(context).colorScheme.tertiary,
        inactiveColorPrimary: Colors.white,
        textStyle:
        Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.wallet_rounded),
        title: portfolioText,
        activeColorPrimary: Theme.of(context).colorScheme.tertiary,
        inactiveColorPrimary: Colors.white,
        textStyle:
        Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.add,
          size: 32,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: connectText,
        activeColorPrimary: Theme.of(context).colorScheme.tertiary,
        inactiveColorPrimary: Colors.white,
        textStyle:
        Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
        onPressed: (_) {
          // pushNewScreen oculta a bottom bar nesta rota
          PersistentNavBarNavigator.pushNewScreen(
            context,
            screen: const AddResource(),
            withNavBar: false,
          );
        },
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.lightbulb),
        title: discoverText,
        activeColorPrimary: Theme.of(context).colorScheme.tertiary,
        inactiveColorPrimary: Colors.white,
        textStyle:
        Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.travel_explore),
        title: exploreText,
        activeColorPrimary: Theme.of(context).colorScheme.tertiary,
        inactiveColorPrimary: Colors.white,
        textStyle:
        Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
      ),
    ];
  }

  @override
  Widget render(BuildContext context) {
    return UpgradeAlert(
      upgrader: Upgrader(
        // Na versão 11.4.0 do upgrader já não existem mais
        // `dialogStyle` nem `shouldPopScope`.
        countryCode: 'BR',
      ),
      child: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),

        // OBS: todas estas propriedades abaixo não existem em 6.2.1,
        // então foram removidas:
        //
        //   • confineInSafeArea
        //   • hideNavigationBarWhenKeyboardShows
        //   • popActionScreens
        //   • itemAnimationProperties
        //   • screenTransitionAnimation
        //
        // Se você precisar de “esconder ao abrir teclado” ou “popar
        // telas filhas” de modo customizado, terá de implementar
        // manualmente usando um KeyboardVisibilityBuilder, ou
        // observando o controller de abas.

        // 4) Decoração do nav bar (bordas, cor atrás etc.)
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Theme.of(context).cardColor,
        ),

        // 5) Outras configurações
        backgroundColor: Theme.of(context).cardColor,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,

        // 7) Estilo do nav bar (mantido como style15)
        navBarStyle: NavBarStyle.style15,

        // 8) Callback ao selecionar uma aba
        onItemSelected: (index) {
          setState(() {
            _controller.index = index;
          });
        },
      ),
    );
  }
}