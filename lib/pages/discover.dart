import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:wisemade_app_core/infrastructure/wisemade_api.dart';
import 'package:wisemade_app_core/widgets/shared/coin_list.dart';

import '../app_state.dart';
import '../main.dart';
import '../models/coin.dart';
import '../widgets/shared/appbar.dart';
import '../widgets/shared/filter_chips_carousel.dart';
import 'authenticated_page.dart';

class DiscoverPage extends AuthenticatedPage {
  const DiscoverPage({super.key});

  @override
  AuthenticatedPageState<DiscoverPage> createState() => _MarketCoinsPageState();
}

class _MarketCoinsPageState extends AuthenticatedPageState<DiscoverPage> {
  Map<String, List<Coin>> mainCoins = { 'trending' : [], 'ranking' : [], 'top gainers': [], 'top engaged': [] };
  Map<String, List<Coin>> categoryCoins = { 'smart_contracts' : [], 'defi' : [], 'nft': [], 'metaverse': [], 'ai': [], 'play_to_earn': [], 'sports': [] };
  String selectedMainFilter = 'top engaged';
  String selectedCategoriesFilter = 'smart_contracts';

  Future getData() async {
    AppState appState = Provider.of<AppState>(context, listen: false);
    appState.context = context;

    String fiatSymbol = appState.currentUser?.fiatSymbol ?? 'usd';
    final List data = await Future.wait([
      ...(categoryCoins.keys.map((category) => WisemadeApi(context).fetchCoinsByCategory(category, fiatSymbol: fiatSymbol)).toList()),
      appState.getFamousCoins(),
      appState.getTrendingCoins(),
      appState.getTopEngagedCoins(),
      appState.getTopGainersCoins(),
    ]);

    setState(() {
      mainCoins['ranking'] = appState.famousCoins;
      mainCoins['trending'] = appState.trendingCoins;
      mainCoins['top engaged'] = appState.topEngagedCoins;
      mainCoins['top gainers'] = appState.topGainersCoins;
      categoryCoins['smart_contracts'] = data[0];
      categoryCoins['defi'] = data[1];
      categoryCoins['nft'] = data[2];
      categoryCoins['metaverse'] = data[3];
      categoryCoins['ai'] = data[4];
      categoryCoins['play_to_earn'] = data[5];
      categoryCoins['sports'] = data[6];
    });

    appState.shouldFetchDashboardData = false;
  }

  @override
  void initState() {
    getData();

    super.initState();
  }

  Future<void> _pullRefresh() async {
    await getData();
  }

  @override
  Widget render(BuildContext context) {
    mixpanel.track('Viewed Screen - Discover');

    final titleText = FlutterI18n.translate(context, 'navbar.discover');

    final engagementText = FlutterI18n.translate(context, 'discover.filters.market.engagement');
    final trendingText = FlutterI18n.translate(context, 'discover.filters.market.trending');
    final topGainersText = FlutterI18n.translate(context, 'discover.filters.market.top_gainers');
    final marketCapText = FlutterI18n.translate(context, 'discover.filters.market.market_cap');

    final smartContractsText = FlutterI18n.translate(context, 'discover.filters.categories.smart_contracts');
    final defiText = FlutterI18n.translate(context, 'discover.filters.categories.defi');
    final nftText = FlutterI18n.translate(context, 'discover.filters.categories.nft');
    final metaverseText = FlutterI18n.translate(context, 'discover.filters.categories.metaverse');
    final aiText = FlutterI18n.translate(context, 'discover.filters.categories.ai');
    final playToEarnText = FlutterI18n.translate(context, 'discover.filters.categories.play_to_earn');
    final sportsText = FlutterI18n.translate(context, 'discover.filters.categories.sports');

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: CustomAppBar(preferredSize: const Size.fromHeight(70), withSearch: true, withAvatar: true, title: titleText),
      body: SafeArea(
        child: Consumer<AppState>(
            builder: (context, state, child) {
              return RefreshIndicator(
                  onRefresh: _pullRefresh,
                  child: SingleChildScrollView(
                    clipBehavior: Clip.none,
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FilterChipsCarousel(
                              selected: selectedMainFilter,
                              options: [
                                { 'label' : engagementText, 'value' : 'top engaged' },
                                { 'label' : trendingText, 'value' : 'trending' },
                                { 'label' : marketCapText, 'value' : 'ranking' },
                                { 'label' : topGainersText, 'value' : 'top gainers' }
                              ],
                              onSelect: (option) {
                                setState(() { selectedMainFilter = option; });
                                mixpanel.track('Selected Filter', properties: { 'filter' : option });
                              }
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: CoinList(
                                coins: mainCoins[selectedMainFilter] as List<Coin>,
                                favorites: state.favoriteCoins
                              )
                            ),
                            FilterChipsCarousel(
                                selected: selectedCategoriesFilter,
                                options: [
                                  { 'label' : smartContractsText, 'value' : 'smart_contracts' },
                                  { 'label' : aiText, 'value' : 'ai' },
                                  { 'label' : defiText, 'value' : 'defi' },
                                  { 'label' : nftText, 'value' : 'nft' },
                                  { 'label' : metaverseText, 'value' : 'metaverse' },
                                  { 'label' : playToEarnText, 'value' : 'play_to_earn' },
                                  { 'label' : sportsText, 'value' : 'sports' },
                                ],
                                onSelect: (option) {
                                  setState(() { selectedCategoriesFilter = option; });
                                  mixpanel.track('Selected Filter', properties: { 'filter' : option });
                                }
                            ),
                            Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: CoinList(
                                  coins: categoryCoins[selectedCategoriesFilter] as List<Coin>,
                                  favorites: state.favoriteCoins
                                )
                            ),
                          ]
                      )
                    )
                  )
              );
            }
        )
      )
    );
  }
}