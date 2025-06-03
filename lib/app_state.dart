// lib/app_state.dart

// ──────────────────────────────────────────────────────────────────────────
// [1] Imports corrigidos e organizados
// ──────────────────────────────────────────────────────────────────────────

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

// Import correto para persistent_bottom_nav_bar v6.2.1:
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import 'package:provider/provider.dart';

import 'package:wisemade_app_core/infrastructure/wisemade_api.dart';
import 'package:wisemade_app_core/infrastructure/polygon_api.dart';

import 'package:wisemade_app_core/models/coin.dart';
import 'package:wisemade_app_core/models/my_coin.dart';
import 'package:wisemade_app_core/models/asset_holder.dart';
import 'package:wisemade_app_core/models/exchange.dart';
import 'package:wisemade_app_core/models/news.dart';
import 'package:wisemade_app_core/models/portfolio_snapshot.dart';
import 'package:wisemade_app_core/models/transaction.dart';
import 'package:wisemade_app_core/models/user.dart';
import 'package:wisemade_app_core/models/video.dart';
import 'package:wisemade_app_core/models/hathor_wallet.dart';

import 'package:wisemade_app_core/pages/app.dart';
import 'package:wisemade_app_core/pages/intro.dart';
import 'package:wisemade_app_core/pages/setup.dart';
import 'package:wisemade_app_core/pages/sync_wallet_loading.dart';

import 'package:wisemade_app_core/usecases/add_transaction.dart';


// ──────────────────────────────────────────────────────────────────────────
// [2] Definição de AppState
// ──────────────────────────────────────────────────────────────────────────

class AppState extends ChangeNotifier {
  BuildContext? context;

  AppState({ this.context }) {
    initializeLocale();
    _initializePagingControllers();
  }

  // ────────────────────────────────────────────────────────────────────────
  // [2.1] Estados e Listas de Dados
  // ────────────────────────────────────────────────────────────────────────

  List<News> news = [];
  List<News> coinNews = [];
  List<Exchange> exchanges = [];
  List<Coin> portfolioCoins = [];
  List<MyCoin> hathorWalletCoins = [];
  List<Coin> favoriteCoins = [];
  List<Coin> trendingCoins = [];
  List<Coin> topGainersCoins = [];
  List<Coin> topEngagedCoins = [];
  List<Coin> famousCoins = [];
  List<Coin> searchedCoins = [];
  List<AssetHolder> assetHolders = [];
  List<Transaction> coinTransactions = [];
  List<Video> videos = [];
  HathorWallet? hathorWallet;
  Coin? coin;
  Coin? coinOfTheDay;
  User? currentUser;
  Map<String, dynamic>? avatarMetadata;
  Map<String, dynamic>? performanceReport;
  PortfolioSnapshot? portfolioSnapshot;
  AssetHolder? selectedAssetHolder;
  num? coinPrice;

  int searchedCoinsCount = 0;
  int portfolioCoinsCount = 0;
  int hathorWalletCoinsCount = 0;
  int coinTransactionsCount = 0;

  bool currentUserLoading = true;
  bool portfolioSnapshotLoading = true;
  bool portfolioCoinsLoading = true;
  bool hathorWalletCoinsLoading = true;
  bool hathorWalletLoading = true;
  bool assetHoldersLoading = true;
  bool coinOfTheDayLoading = true;
  bool favoriteCoinsLoading = true;
  bool famousCoinsLoading = false;
  bool topEngagedCoinsLoading = false;
  bool trendingCoinsLoading = false;
  bool searchedCoinsLoading = false;
  bool addTransactionLoading = false;
  bool addWalletLoading = false;
  bool newsLoading = false;
  bool coinNewsLoading = false;
  bool performanceReportLoading = false;

  bool shouldFetchDashboardData = true;
  bool shouldFetchCockpitData = true;

  // ────────────────────────────────────────────────────────────────────────
  // [2.1.1] Variáveis auxiliares para paginação (v5.x)
  // ────────────────────────────────────────────────────────────────────────

  static const int _pageSizePortfolio    = 10;
  static const int _pageSizeHathor       = 10;
  static const int _pageSizeTransactions = 10;
  static const int _pageSizeSearch       = 15;

  int _portfolioCoinsTotalCount    = 0;
  int _hathorWalletCoinsTotalCount = 0;
  int _coinTransactionsTotalCount  = 0;
  int _searchedCoinsTotalCount     = 0;

  MyCoin? _currentCoinForTransactions;
  String? _currentSearchQuery;
  String? _currentSearchCategory;
  Exchange? _currentSearchExchange;

  // ────────────────────────────────────────────────────────────────────────
  // [2.2] PagingControllers (v5.x do infinite_scroll_pagination)
  // ────────────────────────────────────────────────────────────────────────

  late final PagingController<int, MyCoin> coinsPagingController;
  late final PagingController<int, MyCoin> hathorWalletCoinsPagingController;
  late final PagingController<int, Transaction> transactionsPagingController;
  late final PagingController<int, Coin> searchedCoinsPagingController;

  // ────────────────────────────────────────────────────────────────────────
  // [2.3] Controller do Bottom Navigation Bar
  // ────────────────────────────────────────────────────────────────────────

  /// Controller para o PersistentBottomNavBar v6.2.1
  final PersistentTabController tabController =
  PersistentTabController(initialIndex: 0);

  String currentLocale = Platform.localeName.split('_')[0];


  // ────────────────────────────────────────────────────────────────────────
  // [2.4] Inicialização dos PagingControllers (v5.x)
  // ────────────────────────────────────────────────────────────────────────

  void _initializePagingControllers() {
    coinsPagingController = PagingController<int, MyCoin>(
      getNextPageKey: (state) {
        final lastKey = state.keys?.last ?? 0;
        final loadedCount = state.items?.length ?? 0;
        final isLastPage = loadedCount >= _portfolioCoinsTotalCount;
        return isLastPage ? null : lastKey + 1;
      },
      fetchPage: (pageKey) => _fetchPortfolioCoinsPage(pageKey),
    );

    hathorWalletCoinsPagingController = PagingController<int, MyCoin>(
      getNextPageKey: (state) {
        final lastKey = state.keys?.last ?? 0;
        final loadedCount = state.items?.length ?? 0;
        final isLastPage = loadedCount >= _hathorWalletCoinsTotalCount;
        return isLastPage ? null : lastKey + 1;
      },
      fetchPage: (pageKey) => _fetchHathorWalletCoinsPage(pageKey),
    );

    transactionsPagingController = PagingController<int, Transaction>(
      getNextPageKey: (state) {
        final lastKey = state.keys?.last ?? 0;
        final loadedCount = state.items?.length ?? 0;
        final isLastPage = loadedCount >= _coinTransactionsTotalCount;
        return isLastPage ? null : lastKey + 1;
      },
      fetchPage: (pageKey) => _fetchCoinTransactionsPage(pageKey),
    );

    searchedCoinsPagingController = PagingController<int, Coin>(
      getNextPageKey: (state) {
        final lastKey = state.keys?.last ?? 0;
        final loadedCount = state.items?.length ?? 0;
        final isLastPage = loadedCount >= _searchedCoinsTotalCount;
        return isLastPage ? null : lastKey + 1;
      },
      fetchPage: (pageKey) => _fetchSearchedCoinsPage(pageKey),
    );
  }

  Future<void> addTransaction(Map<String, dynamic> payload) async {
    addTransactionLoading = true;
    await AddTransactionUseCase(context!).run(payload);

    addTransactionLoading = false;
    portfolioSnapshot = null;
    portfolioCoinsLoading = true;
    shouldFetchDashboardData = true;
    shouldFetchCockpitData = true;
    notifyListeners();

    tabController.jumpToTab(0);

    final successText = FlutterI18n.translate(context!, 'add_transaction.success');
    ScaffoldMessenger.of(context!).showSnackBar(
      SnackBar(
        content: Text(successText),
        backgroundColor: const Color(0xff9CFF9A),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        elevation: 10,
      ),
    );
  }

  Future<void> addWallet(Map<String, dynamic> payload) async {
    addWalletLoading = true;

    try {
      await WisemadeApi(context!).addWallet(payload);
      await getAssetHolders();

      addWalletLoading = false;
      portfolioSnapshot = null;
      portfolioCoinsLoading = true;
      shouldFetchDashboardData = true;
      shouldFetchCockpitData = true;
      notifyListeners();

      Navigator.of(context!).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const SyncWalletLoading(),
            settings: const RouteSettings(name: '/sync-wallet-loading'),
          ),
              (route) => false
      );
    } on UnprocessableEntity catch (_) {
      final errorText = FlutterI18n.translate(context!, 'add_wallet.already_exists_error');
      ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(
          content: Text(errorText, style: Theme.of(context!).textTheme.bodyMedium?.copyWith(color: Colors.white)),
          backgroundColor: Theme.of(context!).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(20),
          elevation: 10,
        ),
      );
    } catch (_) {
      final errorText = FlutterI18n.translate(context!, 'add_wallet.generic_error');
      ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(
          content: Text(errorText, style: Theme.of(context!).textTheme.bodyMedium?.copyWith(color: Colors.white)),
          backgroundColor: Theme.of(context!).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(20),
          elevation: 10,
        ),
      );
    }
  }


  // ────────────────────────────────────────────────────────────────────────
  // [3] Métodos Privados de “fetchPage” (infinite_scroll_pagination v5.x)
  // ────────────────────────────────────────────────────────────────────────

  /// 3.1. Páginas do portfólio
  Future<List<MyCoin>> _fetchPortfolioCoinsPage(int pageKey) async {
    final response = await WisemadeApi(context!).fetchPortfolioCoinsSummary(
      pageKey,
      perPage: _pageSizePortfolio,
      exchangePortfolioId: selectedAssetHolder?.id,
    );
    final newItems = response['coins'] as List<MyCoin>;
    _portfolioCoinsTotalCount = response['count'] as int;
    return newItems;
  }

  /// 3.2. Páginas da carteira Hathor
  Future<List<MyCoin>> _fetchHathorWalletCoinsPage(int pageKey) async {
    final response = await WisemadeApi(context!).fetchHathorWalletCoins(
      pageKey,
      perPage: _pageSizeHathor,
    );
    final newItems = response['coins'] as List<MyCoin>;
    _hathorWalletCoinsTotalCount = response['count'] as int;
    return newItems;
  }

  /// 3.3. Páginas de transações (precisa saber qual coin está sendo paginada)
  Future<List<Transaction>> _fetchCoinTransactionsPage(int pageKey) async {
    if (_currentCoinForTransactions == null) return <Transaction>[];

    final response = await WisemadeApi(context!).fetchCoinTransactions(
      _currentCoinForTransactions!,
      pageKey,
      assetHolderId: selectedAssetHolder?.id,
    );
    final newItems = response['transactions'] as List<Transaction>;
    _coinTransactionsTotalCount = response['count'] as int;
    return newItems;
  }

  /// 3.4. Páginas de moedas buscadas
  Future<List<Coin>> _fetchSearchedCoinsPage(int pageKey) async {
    final responseList = await WisemadeApi(context!).searchCoins(
      query: _currentSearchQuery,
      category: _currentSearchCategory,
      exchange: _currentSearchExchange,
      page: pageKey,
      perPage: _pageSizeSearch,
      callback: (headers) {
        _searchedCoinsTotalCount = int.parse(headers['total'] ?? '0');
      },
    );
    return responseList;
  }


  // ────────────────────────────────────────────────────────────────────────
  // [4] Métodos Públicos de paginação (v5.x)
  // ────────────────────────────────────────────────────────────────────────

  /// Carrega do zero as moedas do portfólio (inicia paginação)
  void carregarPortfolioCoinsDoZero() {
    portfolioCoins.clear();
    _portfolioCoinsTotalCount = 0;
    coinsPagingController.refresh();
  }

  /// Carrega do zero as moedas da carteira Hathor (inicia paginação)
  void carregarHathorWalletCoinsDoZero() {
    hathorWalletCoins.clear();
    _hathorWalletCoinsTotalCount = 0;
    hathorWalletCoinsPagingController.refresh();
  }

  /// Inicia paginação de transações para a moeda selecionada
  void carregarTransacoesParaCoin(MyCoin coin) {
    _currentCoinForTransactions = coin;
    coinTransactions.clear();
    _coinTransactionsTotalCount = 0;
    transactionsPagingController.refresh();
  }

  /// Inicia paginação de moedas buscadas, definindo parâmetros de busca
  void buscarCoins({ Exchange? exchange, String? category, String? query }) {
    _currentSearchExchange = exchange;
    _currentSearchCategory = category;
    _currentSearchQuery = query;
    searchedCoins.clear();
    _searchedCoinsTotalCount = 0;
    searchedCoinsPagingController.refresh();
  }


  // ────────────────────────────────────────────────────────────────────────
  // [5] Métodos Públicos restantes (sem paginação)
  // ────────────────────────────────────────────────────────────────────────

  /// Recarrega o estado da aplicação
  Future<void> resetAppState() async {
    shouldFetchDashboardData = true;
    shouldFetchCockpitData = true;
    portfolioSnapshot = null;
    assetHolders = [];
    portfolioCoinsCount = 0;
    coinTransactionsCount = 0;
    portfolioCoinsLoading = true;
    hathorWalletCoinsLoading = true;
    coinTransactions = [];
    currentUser = null;
    avatarMetadata = null;
    favoriteCoins = [];
    favoriteCoinsLoading = true;
    notifyListeners();
  }

  /// Busca notícias do portfólio
  Future<void> getNews() async {
    newsLoading = true;
    final lang = currentLocale;
    news = await WisemadeApi(context!).fetchPortfolioNews(lang: lang);
    newsLoading = false;
    notifyListeners();
  }

  /// Busca notícias de uma moeda específica
  Future<void> getCoinNews(String slug, { String lang = 'en' }) async {
    coinNewsLoading = true;
    final language = currentLocale;  // mantém o comportamento antigo
    coinNews = await WisemadeApi(context!).fetchCoinNews(slug, lang: language);
    coinNewsLoading = false;
    notifyListeners();
  }

  /// Busca todas as moedas do portfólio (sem paginação)
  Future<void> getPortfolioCoins() async {
    portfolioCoinsLoading = true;
    portfolioCoins = await WisemadeApi(context!).fetchPortfolioCoins();
    portfolioCoinsLoading = false;
    notifyListeners();
  }

  /// Busca todas as exchanges (sem paginação)
  Future<void> getExchanges({ String? query }) async {
    exchanges = await WisemadeApi(context!).fetchExchanges();
    notifyListeners();
  }

  /// Busca vídeos (sem paginação)
  Future<void> getVideos() async {
    videos = await WisemadeApi(context!).fetchVideos(lang: currentLocale);
    notifyListeners();
  }

  /// Busca ativos (asset holders)
  Future<void> getAssetHolders({ Function? callback }) async {
    assetHoldersLoading = true;
    assetHolders = await WisemadeApi(context!).fetchPortfolioExchanges();
    assetHoldersLoading = false;
    notifyListeners();
    if (callback != null) callback(assetHolders);
  }

  /// Busca a carteira Hathor completa (sem paginação)
  Future<void> getHathorWallet() async {
    hathorWalletLoading = true;
    hathorWallet = await WisemadeApi(context!).fetchHathorWallet();
    hathorWalletLoading = false;
    notifyListeners();
  }

  /// Busca snapshot do portfólio (sem paginação)
  Future<void> getPortfolioSnapshot({ int? exchangePortfolioId, bool refresh = false }) async {
    if (refresh) {
      portfolioSnapshotLoading = true;
      portfolioSnapshot = null;
    }
    portfolioSnapshot = await WisemadeApi(context!).fetchPortfolioSnapshot(exchangePortfolioId: exchangePortfolioId);
    portfolioSnapshotLoading = false;
    notifyListeners();
  }

  /// Busca dados de moeda única (sem paginação)
  Future<void> getCoin(String slug) async {
    coin = null;
    coin = await WisemadeApi(context!).fetchCoin(slug, lang: currentLocale, fiatSymbol: currentUser!.fiatSymbol);
    notifyListeners();
  }

  /// Busca relatório de desempenho (performance report)
  Future<void> getPerformanceReport() async {
    performanceReportLoading = true;
    performanceReport = await WisemadeApi(context!).fetchPerformanceReport();
    performanceReportLoading = false;
    notifyListeners();
  }

  /// Busca "coin of the day" (moeda do dia)
  Future<void> getCoinOfTheDay() async {
    coinOfTheDayLoading = true;
    coinOfTheDay = await WisemadeApi(context!).fetchCoinOfTheDay(fiatSymbol: currentUser!.fiatSymbol);
    coinOfTheDayLoading = false;
    notifyListeners();
  }

  /// Busca moedas favoritas do usuário
  Future<void> getFavoriteCoins() async {
    favoriteCoinsLoading = true;
    favoriteCoins = await WisemadeApi(context!).fetchFavoriteCoins(fiatSymbol: currentUser!.fiatSymbol);
    favoriteCoinsLoading = false;
    notifyListeners();
  }

  /// Busca moedas famosas (sem paginação)
  Future<void> getFamousCoins() async {
    famousCoinsLoading = true;
    famousCoins = await WisemadeApi(context!).fetchFamousCoins(fiatSymbol: currentUser!.fiatSymbol);
    famousCoinsLoading = false;
    notifyListeners();
  }

  /// Busca moedas em alta (trending)
  Future<void> getTrendingCoins() async {
    trendingCoinsLoading = true;
    trendingCoins = (await WisemadeApi(context!).fetchTrendingCoins(fiatSymbol: currentUser!.fiatSymbol)).take(10).toList();
    trendingCoinsLoading = false;
    notifyListeners();
  }

  /// Busca top gainers
  Future<void> getTopGainersCoins() async {
    topGainersCoins = (await WisemadeApi(context!).fetchTopGainersCoins(fiatSymbol: currentUser!.fiatSymbol)).take(10).toList();
    notifyListeners();
  }

  /// Busca top engaged
  Future<void> getTopEngagedCoins() async {
    topEngagedCoinsLoading = true;
    topEngagedCoins = (await WisemadeApi(context!).fetchTopEngagedCoins(fiatSymbol: currentUser!.fiatSymbol)).take(10).toList();
    topEngagedCoinsLoading = false;
    notifyListeners();
  }

  /// Busca preço de uma moeda específica
  Future<void> getCoinPrice(Coin coin) async {
    coinPrice = await WisemadeApi(context!).fetchCoinPrice(coin);
    notifyListeners();
  }

  /// Busca informações do usuário atual
  Future<User?> getCurrentUser({ Function? callback }) async {
    try {
      currentUserLoading = true;
      currentUser = await WisemadeApi(context!).fetchCurrentUser();
      currentUserLoading = false;
      notifyListeners();

      if (avatarMetadata == null) {
        getAvatarNFT();
      }
      if (callback != null) callback();
      return currentUser!;
    } on Exception catch (_, e) {
      // Se algo der errado, limpa sessão e retorna à IntroPage
      AppState appState = Provider.of<AppState>(context!, listen: false);
      var session = SessionManager();
      await appState.resetAppState();
      await session.destroy();

      PersistentNavBarNavigator.pushNewScreen(
        context!,
        screen: const IntroPage(),
        withNavBar: false,
      );
      return null;
    }
  }

  /// Faz setup inicial do usuário (metadados)
  Future<void> setupUser(Map<String, dynamic> metadata) async {
    await WisemadeApi(context!).setupUser(metadata);
    Navigator.of(context!).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const AppPage()),
          (route) => false,
    );
  }

  /// Configura moeda fiduciária
  Future<void> setupFiat(String fiat) async {
    await WisemadeApi(context!).setupFiat(fiat);
  }

  /// Alterna favorito para uma moeda
  Future<void> toggleFavorite(Coin coin) async {
    await WisemadeApi(context!).toggleFavorite(coin);
    notifyListeners();
    getFavoriteCoins();
  }

  /// Busca metadados do avatar NFT (Polygon)
  Future<void> getAvatarNFT() async {
    if (currentUser?.avatar != null && avatarMetadata == null) {
      avatarMetadata = await PolygonApi().getNFTMeta(
        currentUser!.avatar?['contractAddress'],
        currentUser!.avatar?['tokenId'],
      );
      notifyListeners();
    }
  }

  /// Limpa preço da moeda atual
  Future<void> clearCoinPrice() async {
    coinPrice = null;
    notifyListeners();
  }

  /// Seleciona AssetHolder e atualiza dados relacionados
  void selectAssetHolder(AssetHolder? ah) async {
    selectedAssetHolder = ah;
    if (ah?.id != null) getAssetHolder(ah!.id!, type: ah?.type);
    await getPortfolioSnapshot(exchangePortfolioId: ah?.id, refresh: true);
    // Em vez de chamar getPortfolioCoinsSummary, utilizamos a paginação:
    portfolioCoins.clear();
    coinsPagingController.refresh();
  }

  /// Deleta uma transação
  Future<List<void>> deleteTransaction(Transaction transaction) async {
    await WisemadeApi(context!).deleteTransaction(transaction);
    notifyListeners();

    // Após deletar, recarrega transações e dados do portfólio do zero:
    _currentCoinForTransactions = transaction.coin;
    coinTransactions.clear();
    transactionsPagingController.refresh();
    coinsPagingController.refresh();
    await getPortfolioSnapshot();
    return [];
  }

  /// Deleta um AssetHolder (exchange ou wallet)
  Future<List<void>> deleteAssetHolder(int exchangePortfolioId, { String? type = 'exchange' }) async {
    if (type == 'exchange') {
      await WisemadeApi(context!).deleteExchangePortfolio(exchangePortfolioId);
    } else {
      await WisemadeApi(context!).deleteWallet(exchangePortfolioId);
    }

    selectAssetHolder(null);
    notifyListeners();

    coinsPagingController.refresh();
    await getPortfolioSnapshot();
    await getAssetHolders();
    return [];
  }

  /// Busca um AssetHolder específico e o atualiza na lista
  Future<void> getAssetHolder(int assetHolderId, { String? type = 'exchange' }) async {
    AssetHolder? assetHolder;
    if (type == 'exchange') {
      assetHolder = await WisemadeApi(context!).fetchExchangePortfolio(assetHolderId);
    } else {
      assetHolder = await WisemadeApi(context!).fetchWallet(assetHolderId);
    }

    assetHolders = assetHolders.map((ah) {
      if (ah.id == assetHolder?.id) {
        return assetHolder!;
      } else {
        return ah;
      }
    }).toList();

    notifyListeners();
  }

  /// Inicializa o locale com valor salvo na sessão
  Future<void> initializeLocale() async {
    final locale = await SessionManager().get('locale');
    currentLocale = locale ?? currentLocale;
    notifyListeners();
  }

  /// Altera o locale (idioma) da aplicação
  Future<void> setLocale(String locale) async {
    await SessionManager().set('locale', locale);
    currentLocale = locale;
    notifyListeners();
    getNews();
    getVideos();
  }
}