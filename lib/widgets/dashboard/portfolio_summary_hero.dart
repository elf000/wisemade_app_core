import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:wisemade_app_core/models/portfolio_snapshot.dart';
import 'package:wisemade_app_core/widgets/dashboard/balance_summary.dart';

import '../../app_state.dart';
import '../../pages/performance_report.dart';
import '../../pages/webview_screen.dart';

class PortfolioSummaryHero extends StatefulWidget {
  const PortfolioSummaryHero({
    Key? key,
  }) : super(key: key);

  @override
  State<PortfolioSummaryHero> createState() => _PortfolioSummaryHeroState();
}

class _PortfolioSummaryHeroState extends State<PortfolioSummaryHero> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, child) {
        PortfolioSnapshot? portfolioSnapshot = state.portfolioSnapshot;
        Map<String, dynamic>? performanceReport = state.performanceReport;
        bool hasSyncingAssetHolder = state.assetHolders.any((assetHolder) => assetHolder.syncing == true);

        return Container(
          height: 320,
          margin: const EdgeInsets.only(top: 50),
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
          child: !state.currentUserLoading && state.currentUser?.metamaskPublicAddress == null ? ListView(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            children: [
              BalanceSummaryCard(
                portfolioSnapshot: portfolioSnapshot,
                performanceReport: performanceReport,
                loading: state.portfolioSnapshotLoading,
                syncing: hasSyncingAssetHolder,
              ),
              Card(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Text("Você ganhou um NFT", style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70))
                            ),
                            Container(
                                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Text("Resgate aqui 🎉", style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold))
                            ),
                            Container(
                                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: OutlinedButton(
                                  onPressed: () {
                                    PersistentNavBarNavigator.pushNewScreen(
                                      context,
                                      screen: const WebviewScreen(url: 'https://blog.wisemade.io/tutorial-nft', title: 'Como resgatar seu NFT'),
                                      withNavBar: false,
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.deepPurple)),
                                  child: const Text('Resgatar seu NFT'),
                                )
                            ),
                          ],
                        )
                    ),
                    Positioned.fill(
                      top: -310,
                      child: Align(
                          alignment: Alignment.center,
                          child: Image.asset('images/owl-with-nft.png', width: 130)
                      ),
                    ),
                  ]
                )
              )
            ]
          ) : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BalanceSummaryCard(
                portfolioSnapshot: portfolioSnapshot,
                performanceReport: performanceReport,
                loading: state.portfolioSnapshotLoading,
                syncing: hasSyncingAssetHolder,
              )
            ]
          )
        );
      }
    );
  }
}

class BalanceSummaryCard extends StatelessWidget {
  const BalanceSummaryCard({
    super.key,
    required this.portfolioSnapshot,
    this.performanceReport,
    this.loading = false,
    this.syncing = false
  });

  final PortfolioSnapshot? portfolioSnapshot;
  final Map<String, dynamic>? performanceReport;
  final bool loading;
  final bool syncing;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Text("Meu saldo", style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70))
              ),
              BalanceSummary(portfolioSnapshot: portfolioSnapshot, loading: loading, syncing: syncing),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if(portfolioSnapshot != null && portfolioSnapshot!.balance > 0) Container(
                      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(5)),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      margin: const EdgeInsets.only(top: 20),
                      child: InkWell(
                        child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 5),
                                child: Icon(Icons.area_chart_sharp, size: 16, color: Theme.of(context).colorScheme.secondary),
                              ),
                              Text('Ver portfolio', style: Theme.of(context).textTheme.bodySmall),
                            ]
                        ),
                        onTap: () {
                          AppState appState = Provider.of<AppState>(context, listen: false);
                          appState.tabController.jumpToTab(1);
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                      )
                  ),
                  if(performanceReport != null) Container(
                      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(5)),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      margin: const EdgeInsets.only(top: 20),
                      child: InkWell(
                        child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 5),
                                child: Icon(Icons.insights, size: 16, color: Theme.of(context).colorScheme.secondary),
                              ),
                              Text('Performance', style: Theme.of(context).textTheme.bodySmall),
                            ]
                        ),
                        onTap: () {
                          PersistentNavBarNavigator.pushDynamicScreen(
                            context,
                            screen: MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => const PerformanceReportPage()
                            ),
                            withNavBar: false,
                          );
                        },
                      )
                  ),
                ]
              )
            ],
          )
        ),
        Positioned.fill(
          top: -290,
          child: Align(
            alignment: Alignment.center,
            child: Image.asset('images/owl-with-bitcoin.png', width: 110)
          ),
        ),
      ]
    );
  }
}

class Card extends StatelessWidget {
  final EdgeInsets? margin;
  final Widget child;

  const Card({
    super.key,
    required this.child,
    this.margin
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(5)),
      width: MediaQuery.of(context).size.width * 0.85,
      child: child
    );
  }
}
