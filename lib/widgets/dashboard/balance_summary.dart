import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '/app_state.dart';
import '/models/portfolio_snapshot.dart';
import '/pages/add_connection.dart';
import '/utils/format.dart';
import '/widgets/shared/percentage.dart';

class BalanceSummary extends StatelessWidget {
  const BalanceSummary({
    super.key,
    required this.portfolioSnapshot,
    this.loading = false,
    this.syncing = false,
  });

  final PortfolioSnapshot? portfolioSnapshot;
  final bool loading;
  final bool syncing;

  Widget shimmerLine({double width = 200, double height = 20}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[700]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppState state = Provider.of<AppState>(context, listen: false);
    final pricePrefix = state.currentUser?.fiatPrefix ?? "\$";

    final addTokenText = FlutterI18n.translate(context, 'portfolio.add_token');
    final portfolioSyncingText = FlutterI18n.translate(
        context, 'home.header.balance_summary.portfolio_syncing');

    return InkWell(
      onTap: () {
        if (portfolioSnapshot != null && portfolioSnapshot!.balance > 0) {
          state.tabController.jumpToTab(1);
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              portfolioSnapshot == null
                  ? shimmerLine(width: 210, height: 40)
                  : Text(
                Format.currency(portfolioSnapshot!.balance,
                    pattern: "$pricePrefix #,##0.00"),
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          if (!loading &&
              portfolioSnapshot != null &&
              portfolioSnapshot!.balance > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Format.currency(portfolioSnapshot!.profit,
                      pattern: "$pricePrefix #,##0.00"),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: portfolioSnapshot!.profit >= 0
                        ? Colors.green[700]
                        : Colors.redAccent[700],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Percentage(
                    value: portfolioSnapshot!.profitPercentage,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          if (!loading &&
              !syncing &&
              portfolioSnapshot != null &&
              portfolioSnapshot!.balance == 0)
            InkWell(
              onTap: () {
                PersistentNavBarNavigator.pushDynamicScreen(
                  context,
                  screen: MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => const AddResource(),
                  ),
                  withNavBar: false,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.add_circle,
                        color: Theme.of(context).colorScheme.tertiary,
                        size: 24.0,
                      ),
                    ),
                    Text(
                      addTokenText,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                          color:
                          Theme.of(context).colorScheme.tertiary),
                    )
                  ],
                ),
              ),
            ),
          if (!loading && syncing)
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    portfolioSyncingText,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70, fontWeight: FontWeight.w300),
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(left: 10),
                    child: const CircularProgressIndicator(strokeWidth: 1),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}