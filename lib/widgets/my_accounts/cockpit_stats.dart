import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';
import 'package:wisemade_app_core/infrastructure/wisemade_api.dart';
import 'package:wisemade_app_core/models/portfolio_snapshot.dart';
import 'package:wisemade_app_core/widgets/shared/list_item.dart';

import '../../app_state.dart';
import '../../models/news.dart';
import '../../utils/format.dart';
import '../shared/list_skeleton.dart';
import '../shared/percentage.dart';

class CockpitStats extends StatefulWidget {
  const CockpitStats({
    Key? key,
  }) : super(key: key);

  @override
  State<CockpitStats> createState() => _CockpitStatsState();
}

class _CockpitStatsState extends State<CockpitStats> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Consumer<AppState>(
          builder: (context, state, child) {
            PortfolioSnapshot? portfolioSnapshot = state.portfolioSnapshot;
            final pricePrefix = state.currentUser?.fiatPrefix ?? "\$";

            final netWorthText = FlutterI18n.translate(context, 'portfolio.stats.net_worth');
            final profitText = FlutterI18n.translate(context, 'portfolio.stats.profit');
            final totalInvestedText = FlutterI18n.translate(context, 'portfolio.stats.total_invested');
            final feesText = FlutterI18n.translate(context, 'portfolio.stats.fees');

            return portfolioSnapshot == null
                ? const ListSkeleton(size: 4, height: 70)
                : Column(
                  children: [
                    Card(
                        label: netWorthText,
                        value: Format.currency(portfolioSnapshot.balance, pattern: '$pricePrefix #,##0.00'),
                        valueStyle: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontWeight: FontWeight.bold)
                    ),
                    Card(
                      label: profitText,
                      value: Format.currency(portfolioSnapshot.profit, pattern: '$pricePrefix #,##0.00'),
                      subValue: Percentage(value: portfolioSnapshot.profitPercentage, style: Theme.of(context).textTheme.bodySmall),
                      valueStyle: Theme.of(context).textTheme.titleMedium,
                    ),
                    Card(
                        label: totalInvestedText,
                        value: Format.currency(portfolioSnapshot.totalInvested, pattern: '$pricePrefix #,##0.00'),
                        valueStyle: Theme.of(context).textTheme.titleMedium
                    ),
                    Card(
                        label: feesText,
                        value: Format.currency(portfolioSnapshot.taxes, pattern: '$pricePrefix #,##0.00'),
                        valueStyle: Theme.of(context).textTheme.titleMedium
                    )
                  ]
                );
          },
        )
      );
  }
}

class Card extends StatelessWidget {
  final String label;
  final String value;
  final Widget? subValue;
  final TextStyle? valueStyle;

  const Card({
    Key? key,
    required this.label,
    required this.value,
    this.subValue,
    this.valueStyle
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListItem(
      height: 70,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Row(
            children: [
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: subValue
              ),
              Text(value, style: Theme.of(context).textTheme.headlineSmall?.merge(valueStyle)),
            ]
        )
      ]
    );
  }
}