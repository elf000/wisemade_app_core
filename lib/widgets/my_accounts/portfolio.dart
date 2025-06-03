import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:wisemade_app_core/widgets/my_accounts/portfolio_coins_summary_list.dart';

import '../../app_state.dart';
import '../../pages/add_connection.dart';
import 'cockpit_header.dart';
import 'cockpit_stats.dart';

class Portfolio extends StatefulWidget {
  const Portfolio({super.key});

  @override
  State<Portfolio> createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> {

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
  Widget build(BuildContext context) {
    final noCoinsText = FlutterI18n.translate(context, 'portfolio.no_coins');
    final noCoinsButtonText = FlutterI18n.translate(context, 'portfolio.no_coins_button');

    return Consumer<AppState>(
      builder: (context, state, child) {
        if(state.shouldFetchCockpitData) getData();

        return (state.assetHoldersLoading || state.assetHolders.isNotEmpty) ? CustomScrollView(
          slivers: [
            SliverList(
                delegate: SliverChildListDelegate([
                  CockpitHeader(onExchangeChange: () => { state.coinsPagingController.refresh() }),
                  const CockpitStats(),
                ])
            ),
            const PortfolioCoinsSummaryList(),
          ]) : Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('images/owl-with-cryptos.png', width: 240),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(noCoinsText, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center)
                      ),
                      ElevatedButton(
                          onPressed: () {
                            PersistentNavBarNavigator.pushDynamicScreen(
                              context!,
                              screen: MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (context) => const AddResource()
                              ),
                              withNavBar: false,
                            );
                          },
                          child: Text(
                            noCoinsButtonText,
                            style: TextStyle(color: Theme.of(context).primaryColor),
                          )
                      )
                    ]
                )
            )
          );
      }
    );
  }
}
