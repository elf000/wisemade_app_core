import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:wisemade_app_core/pages/authenticated_page.dart';
import 'package:wisemade_app_core/pages/coins_search.dart';
import 'package:wisemade_app_core/widgets/coin/description.dart';
import 'package:wisemade_app_core/widgets/coin/header.dart';
import 'package:wisemade_app_core/widgets/coin/news.dart';
import 'package:wisemade_app_core/widgets/coin/score_chip.dart';
import 'package:wisemade_app_core/widgets/coin/sentiment_chip.dart';
import 'package:wisemade_app_core/widgets/coin/sparkline.dart';
import 'package:wisemade_app_core/widgets/coin/stats.dart';
import 'package:wisemade_app_core/widgets/shared/custom_chip.dart';

import '../app_state.dart';
import '../main.dart';
import '../models/coin.dart';
import '../widgets/coin/exchanges_chips.dart';
import '../widgets/coin/prices.dart';
import '../widgets/coin/smart_contracts.dart';
import '../widgets/coin/social_stats.dart';
import '../widgets/coin/statistic_bars.dart';

class CoinPage extends AuthenticatedPage {
  final Coin myCoin;
  const CoinPage({super.key, required this.myCoin});

  @override
  AuthenticatedPageState<CoinPage> createState() => _CoinPageState();
}

class _CoinPageState extends AuthenticatedPageState<CoinPage> {
  @override
  void initState() {
    super.initState();

    getData();
  }

  Future getData() {
    AppState appState = Provider.of<AppState>(context, listen: false);

    return Future.wait([
      appState.getCoin(widget.myCoin.coingeckoSlug),
      appState.getCoinNews(widget.myCoin.coingeckoSlug),
    ]);
  }

  @override
  Widget render(BuildContext context) {
    mixpanel.track('Viewed Screen - Coin', properties: { 'coin_id' : widget.myCoin.id, 'coin_name' : widget.myCoin.shortName });

    final overviewTabText = FlutterI18n.translate(context, 'coin.tabs.overview');
    final detailsTabText = FlutterI18n.translate(context, 'coin.tabs.details');

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.background,
          title: CoinHeader(coin: widget.myCoin, inline: true),
          bottom: TabBar(
              indicatorColor: Theme.of(context).colorScheme.secondary,
              tabs: [
                Tab(text: overviewTabText),
                Tab(text: detailsTabText)
              ]
          ),
        ),
        body: const TabBarView(
          children: [
            OverviewTab(),
            DetailsTab(),
          ]
        )
      )
    );
  }
}

class OverviewTab extends StatelessWidget {
  const OverviewTab({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final latestNewsText = FlutterI18n.translate(context, 'home.news_carousel.title');

    return Consumer<AppState>(
      builder: (context, state, child) {
        Coin? coin = state.coin;

        return CustomScrollView(slivers: [
          SliverList(
              delegate: SliverChildListDelegate([
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                        decoration: BoxDecoration(color: Theme
                            .of(context)
                            .colorScheme
                            .background),
                        child: Row(
                          children: [
                            SentimentChip(
                                value: coin?.stats?['averageSentiment']),
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: ScoreChip(value: coin
                                  ?.stats?['marketPerformanceScore']),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                        decoration: BoxDecoration(color: Theme
                            .of(context)
                            .colorScheme
                            .background),
                        child: CoinPrices(coin: coin),
                      ),
                      Container(
                          margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                          child: CoinSparkline(coin: coin, height: 200)
                      ),
                      if(coin?.stats?['volatility'] != null) Container(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                        decoration: BoxDecoration(color: Theme
                            .of(context)
                            .colorScheme
                            .background),
                        child: StatisticBars(coin: coin),
                      ),
                      Container(
                          margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                          child: Column(
                              children: [
                                CoinStats(coin: coin),
                                CoinNewsCarousel(title: latestNewsText),
                                Container(
                                  margin: const EdgeInsets.fromLTRB(
                                      0, 20, 0, 10),
                                  child: SocialStats(coin: coin),
                                ),
                              ]
                          )
                      )
                    ]
                )
              ])
          )
        ]);
      }
    );
  }
}

class DetailsTab extends StatelessWidget {
  const DetailsTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, child) {
        Coin? coin = state.coin;

        return CustomScrollView(slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.background),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CoinDescription(coin: coin),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Wrap(
                        spacing: 10,
                        children: coin?.categories?.map(
                          (category) => CustomChip(
                            side: BorderSide(color: Theme.of(context).cardColor, width: 1),
                            backgroundColor: Theme.of(context).cardColor,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            label: Text(category),
                            onSelected: (_) {
                              PersistentNavBarNavigator.pushDynamicScreen(
                                context!,
                                screen: MaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (context) => CoinsSearchPage(filters: { 'category': category })
                                ),
                                withNavBar: false,
                              );
                            }
                          )
                        ).toList() ?? []
                      )
                    ),
                    SmartContracts(coin: coin),
                    ExchangesChips(coin: coin)
                  ]
                )
              )
            ])
          )
        ]);
      }
    );
  }
}
