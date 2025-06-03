import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:wisemade_app_core/models/portfolio_snapshot.dart';
import 'package:wisemade_app_core/pages/performance_report.dart';
import 'package:wisemade_app_core/pages/profile.dart';
import 'package:wisemade_app_core/widgets/dashboard/balance_summary.dart';
import 'package:wisemade_app_core/widgets/shared/greetings_header.dart';
import 'package:wisemade_app_core/widgets/shared/nft_avatar.dart';
import 'package:wisemade_app_core/widgets/shared/search_button.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.portfolioSnapshot,
    required this.loading,
    required this.syncing,
    required this.performanceReport,
  });

  final PortfolioSnapshot? portfolioSnapshot;
  final bool loading;
  final bool syncing;
  final Map<String, dynamic>? performanceReport;

  @override
  Widget build(BuildContext context) {
    final seePerformanceText = FlutterI18n.translate(context, 'home.header.see_performance');

    return Container(
        padding: const EdgeInsets.only(top: 80, left: 20, right: 20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GreetingsHeader(),
                    SearchButton()
                  ]
                )
              ),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        PersistentNavBarNavigator.pushDynamicScreen(
                          context,
                          screen: MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => const ProfilePage(),
                          ),
                          withNavBar: false,
                        );
                      },
                      child: const NFTAvatar(size: 90),
                    ),
                    Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BalanceSummary(portfolioSnapshot: portfolioSnapshot, loading: loading, syncing: syncing),
                              if(performanceReport != null && !syncing) Container(
                                  decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(5)),
                                  margin: const EdgeInsets.only(top: 15),
                                  child: InkWell(
                                    child: Row(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(right: 5),
                                            child: Icon(Icons.insights, size: 16, color: Theme.of(context).colorScheme.secondary),
                                          ),
                                          Text(seePerformanceText, style: Theme.of(context).textTheme.bodySmall),
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
                    )
                  ]
              ),
            ]
        )
    );
  }
}
