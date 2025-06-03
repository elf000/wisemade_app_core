import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:wisemade_app_core/app_state.dart';

import 'package:wisemade_app_core/widgets/shared/list_item.dart';

import '../../models/my_coin.dart';
import '../../utils/format.dart';
import '../shared/percentage.dart';

class MyCoinStats extends StatefulWidget {
  final MyCoin coin;

  const MyCoinStats({
    Key? key,
    required this.coin,
  }) : super(key: key);

  @override
  State<MyCoinStats> createState() => _MyCoinStatsState();
}

class _MyCoinStatsState extends State<MyCoinStats> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppState state = Provider.of<AppState>(context);
    final pricePrefix = state.currentUser?.fiatPrefix ?? "\$";

    final balanceText = FlutterI18n.translate(context, 'portfolio.my_coin.balance');
    final profitText = FlutterI18n.translate(context, 'portfolio.my_coin.profit');
    final totalAmountText = FlutterI18n.translate(context, 'portfolio.my_coin.total_amount');
    final totalInvestedText = FlutterI18n.translate(context, 'portfolio.my_coin.total_invested');
    final averageBuyPriceText = FlutterI18n.translate(context, 'portfolio.my_coin.average_buy_price');

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          StatsCard(
            label: balanceText,
            value: Format.currency(widget.coin.balance!, pattern: '$pricePrefix #,##0.00'),
            valueStyle: TextStyle(color: Colors.green[200], fontWeight: FontWeight.bold),
          ),
          StatsCard(
            label: profitText,
            value: Format.currency(widget.coin.profitValue!, pattern: '$pricePrefix #,##0.00'),
            subValue: Percentage(
              value: widget.coin.profitPercentage!,
              style: Theme.of(context).textTheme.bodySmall, // substituído caption → bodySmall
            ),
            valueStyle: Theme.of(context).textTheme.titleMedium,
          ),
          StatsCard(
            label: totalAmountText,
            value: widget.coin.formattedTotalAmount(),
            valueStyle: Theme.of(context).textTheme.titleMedium,
          ),
          StatsCard(
            label: totalInvestedText,
            value: Format.currency(widget.coin.totalInvested!, pattern: '$pricePrefix #,##0.00'),
            valueStyle: Theme.of(context).textTheme.titleMedium,
          ),
          StatsCard(
            label: averageBuyPriceText,
            value: Format.currency(widget.coin.averageBuyPrice!, pattern: '$pricePrefix #,##0.00'),
            valueStyle: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

/// Renomeado de 'Card' para 'StatsCard' para evitar conflito com a
/// classe padrão Flutter 'Card'.
class StatsCard extends StatelessWidget {
  final String label;
  final String value;
  final Widget? subValue;
  final TextStyle? valueStyle;

  const StatsCard({
    Key? key,
    required this.label,
    required this.value,
    this.subValue,
    this.valueStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListItem(
      height: 70,
      key: Key("$label-$value"),
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Row(
          children: [
            if (subValue != null)
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: subValue,
              ),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.merge(valueStyle), // substituído headline5 → headlineMedium
            ),
          ],
        ),
      ],
    );
  }
}