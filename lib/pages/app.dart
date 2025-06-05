// lib/pages/app.dart

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';

import '../app_state.dart';
import '../config.dart';
import '../infrastructure/foxbit_client.dart';
import 'authenticated_page.dart';
import 'home.dart';
import 'explore.dart';
import 'add_connection.dart';
import 'trade.dart';
import 'portfolio.dart';

class AppPage extends AuthenticatedPage {
  const AppPage({super.key});

  @override
  AuthenticatedPageState<AppPage> createState() => _AppPageState();
}

class _AppPageState extends AuthenticatedPageState<AppPage> {
  late PersistentTabController _controller;
  late FoxbitClient _foxbitClient;

  @override
  void initState() {
    super.initState();
    // 1) Busca o AppState para recuperar o controller
    final appState = Provider.of<AppState>(context, listen: false);
    _controller = appState.tabController;
    _controller.jumpToTab(0);

    // 2) Instancia única do FoxbitClient, usando as constantes definidas em config.dart
    _foxbitClient = FoxbitClient(
      apiKey: foxbitApiKey,
      apiSecret: foxbitApiSecret,
      baseUrl: foxbitBaseUrl,
    );
  }

  /// Aqui definimos todas as telas que serão exibidas ao tocar nas abas.
  List<Widget> _buildScreens() {
    return [
      const DashboardPage(),                          // índice 0 → Home
      const ExplorePage(),                            // índice 1 → Explore
      const AddResource(),                            // índice 2 → Add
      TradePage(foxbitClient: _foxbitClient),          // índice 3 → Trade
      const PortfolioPage(),                          // índice 4 → Portfolio
    ];
  }

  /// Aqui configuramos cada item da barra inferior. A ordem deve bater com _buildScreens().
  List<PersistentBottomNavBarItem> _navBarsItems() {
    final homeText = FlutterI18n.translate(context, 'navbar.home');
    final exploreText = FlutterI18n.translate(context, 'navbar.explore');
    final connectText = FlutterI18n.translate(context, 'navbar.connect');
    final tradeText = FlutterI18n.translate(context, 'navbar.trade');
    final portfolioText = FlutterI18n.translate(context, 'navbar.portfolio');

    return [
      // 0) Ícone Home
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: homeText,
        activeColorPrimary: Theme.of(context).colorScheme.tertiary,
        inactiveColorPrimary: Colors.white,
        textStyle:
        Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
      ),
      // 1) Ícone Explore
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.travel_explore),
        title: exploreText,
        activeColorPrimary: Theme.of(context).colorScheme.tertiary,
        inactiveColorPrimary: Colors.white,
        textStyle:
        Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
      ),
      // 2) Ícone Add (botão especial que “pushNewScreen” sem NavBar)
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
          // Ao clicar em Add, abrimos AddResource sem mostrar a NavBar
          PersistentNavBarNavigator.pushNewScreen(
            context,
            screen: const AddResource(),
            withNavBar: false,
          );
        },
      ),
      // 3) Ícone Trade
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.swap_horiz),
        title: tradeText,
        activeColorPrimary: Theme.of(context).colorScheme.tertiary,
        inactiveColorPrimary: Colors.white,
        textStyle:
        Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
      ),
      // 4) Ícone Portfolio
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.wallet_rounded),
        title: portfolioText,
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
        // A partir da versão 11.4.0, não existem mais dialogStyle nem shouldPopScope
        countryCode: 'BR',
      ),
      child: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),

        // ============================
        // DECORAÇÃO E COMPORTAMENTO
        // ============================
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Theme.of(context).cardColor,
        ),
        backgroundColor: Theme.of(context).cardColor,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,

        // ============================
        // ESTILO DA NAVBAR (style15)
        // ============================
        navBarStyle: NavBarStyle.style15,

        // ============================
        // CALLBACK QUANDO MUDAR ABA
        // ============================
        onItemSelected: (index) {
          setState(() {
            _controller.index = index;
          });
        },
      ),
    );
  }
}