// lib/pages/home.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:wisemade_app_core/pages/performance_report.dart';
import 'package:wisemade_app_core/widgets/dashboard/coin_of_the_day.dart';
import 'package:wisemade_app_core/widgets/dashboard/favorite_coins_carousel.dart';
import 'package:wisemade_app_core/widgets/dashboard/home_header.dart';
import 'package:wisemade_app_core/widgets/dashboard/portfolio_coins_carousel.dart';
import 'package:wisemade_app_core/widgets/dashboard/portfolio_news_carousel.dart';
import 'package:wisemade_app_core/widgets/dashboard/portfolio_videos_carousel.dart';

import '../app_state.dart';
import '../main.dart'; // Para acessar a instância global de mixpanel
import '../widgets/dashboard/share_with_friends.dart';
import 'authenticated_page.dart';

class DashboardPage extends AuthenticatedPage {
  const DashboardPage({super.key});

  @override
  AuthenticatedPageState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends AuthenticatedPageState<DashboardPage> {
  bool _syncingHandled = false;
  bool _performanceDisplayed = false; // controla se já mostramos relatório

  @override
  void initState() {
    super.initState();

    // Aguardar o primeiro frame antes de chamar getData()
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = Provider.of<AppState>(context, listen: false);
      if (appState.shouldFetchDashboardData == true) {
        getData();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Mostrar o relatório de performance apenas após o primeiro frame,
    // e somente uma vez.
    if (!_performanceDisplayed) {
      _performanceDisplayed = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showPerformanceReport();
      });
    }
  }

  /// Busca todos os dados principais do dashboard.
  Future<void> getData() async {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.context = context; // atualiza contexto no AppState, caso necessário.

    // Função recursiva que aguarda até que currentUser não seja nulo:
    Future<void> handleCurrentUser() async {
      // Aguardar um pouquinho antes de checar
      await Future.delayed(const Duration(milliseconds: 500));

      if (appState.currentUser == null) {
        // Se ainda não temos currentUser, tentamos novamente
        return handleCurrentUser();
      }

      // Quando currentUser estiver disponível, buscar todos os dados simultaneamente
      await Future.wait([
        appState.getAssetHolders(),
        appState.getNews(),
        appState.getPortfolioCoins(),
        appState.getFavoriteCoins(),
        appState.getPortfolioSnapshot(refresh: true),
        appState.getVideos(),
        appState.getCoinOfTheDay(),
        appState.getPerformanceReport(),
        appState.getAvatarNFT(),
      ]);

      // Como o método getPortfolioCoinsSummary não existe mais,
      // limpamos a lista local e acionamos o refresh no PagingController:
      appState.portfolioCoins.clear();
      appState.coinsPagingController.refresh();

      appState.shouldFetchDashboardData = false;
    }

    await handleCurrentUser();
  }

  /// Verifica se já mostramos o relatório de performance hoje. Se não, exibe em diálogo.
  Future<void> showPerformanceReport() async {
    final appState = Provider.of<AppState>(context, listen: false);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final session = SessionManager();
    final dynamic seenValue = await session.get("seenPerformanceReportAt");

    // Apenas segue se for String e puder parsear
    if (seenValue is String) {
      try {
        final seenDate = DateTime.parse(seenValue);
        final hasAlreadySeen =
            today.compareTo(DateTime(seenDate.year, seenDate.month, seenDate.day)) <= 0;
        if (hasAlreadySeen) {
          return;
        }
      } catch (_) {
        // Ignora erros de parse e continua
      }
    }

    // Se performanceReport for nulo, não exibe nada
    if (appState.performanceReport == null) {
      return;
    }

    // Marca no storage que já vimos hoje e exibe modal após breve delay para animação
    await session.set('seenPerformanceReportAt', now.toIso8601String());

    Future.delayed(const Duration(milliseconds: 500), () {
      PersistentNavBarNavigator.pushDynamicScreen(
        context,
        screen: MaterialPageRoute(
          fullscreenDialog: true,
          builder: (ctx) => const PerformanceReportPage(),
        ),
        withNavBar: false,
      );
    });
  }

  /// Método de “pull to refresh” do RefreshIndicator
  Future<void> _pullRefresh() async {
    await getData();
  }

  @override
  Widget render(BuildContext context) {
    // Rastreia visualização de tela no Mixpanel
    mixpanel.track('Viewed Screen - Home');

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Consumer<AppState>(
        builder: (context, state, child) {
          // Obtemos os dados diretamente do `state` (já é o AppState),
          // não precisamos chamar Provider.of novamente.
          final performanceReport = state.performanceReport;
          final portfolioSnapshot = state.portfolioSnapshot;
          final loading = state.portfolioSnapshotLoading;
          final syncing = state.assetHolders.any((a) => a.syncing == true);

          // Lógica para re-verificar sincronização depois de 10s,
          // se estiver “syncing” e não houver sido tratada.
          if (syncing && !_syncingHandled) {
            _syncingHandled = true;
            Future.delayed(const Duration(seconds: 10), () {
              _syncingHandled = false;
              state.getAssetHolders(callback: (assetHolders) {
                final stillSyncing = assetHolders.any((a) => a.syncing == true);
                if (!stillSyncing) {
                  getData();
                }
              });
            });
          }

          return RefreshIndicator(
            edgeOffset: 30,
            onRefresh: _pullRefresh,
            color: Theme.of(context).colorScheme.secondary,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  expandedHeight: 220,
                  toolbarHeight: 0,
                  floating: false,
                  pinned: true,
                  snap: false,
                  stretch: true,
                  scrolledUnderElevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: HomeHeader(
                      portfolioSnapshot: portfolioSnapshot,
                      loading: loading,
                      syncing: syncing,
                      performanceReport: performanceReport,
                    ),
                    stretchModes: const [StretchMode.zoomBackground],
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 20,
                    child: Stack(
                      children: [
                        Container(
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: CoinOfTheDay()),
                const SliverToBoxAdapter(child: PortfolioCoinsCarousel()),
                const SliverToBoxAdapter(child: FavoriteCoinsCarousel()),
                const SliverToBoxAdapter(child: PortfolioNewsCarousel()),
                const SliverToBoxAdapter(child: PortfolioVideosCarousel()),
                const SliverPadding(
                  padding: EdgeInsets.only(top: 20, bottom: 40),
                  sliver: SliverToBoxAdapter(child: ShareWithFriends()),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}