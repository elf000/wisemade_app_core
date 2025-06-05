import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:wisemade_app_core/app_state.dart';

import '../../models/coin.dart';
import '../../utils/format.dart';
import '../shared/list_shimmer.dart';
import '../shared/percentage.dart';

class CoinStats extends StatefulWidget {
  final Coin? coin;

  const CoinStats({
    Key? key,
    required this.coin,
  }) : super(key: key);

  @override
  State<CoinStats> createState() => _CoinStatsState();
}

class _CoinStatsState extends State<CoinStats> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppState state = Provider.of<AppState>(context);
    final pricePrefix = state.currentUser?.fiatPrefix ?? "\$";

    final titleText = FlutterI18n.translate(context, 'coin.stats.title');
    final marketCapText = FlutterI18n.translate(context, 'coin.stats.market_cap');
    final volumeText = FlutterI18n.translate(context, 'coin.stats.volume');
    final marketDominanceText = FlutterI18n.translate(context, 'coin.stats.market_dominance');
    final circulatingSupplyText = FlutterI18n.translate(context, 'coin.stats.circulating_supply');
    final totalSupplyText = FlutterI18n.translate(context, 'coin.stats.total_supply');
    final maxSupplyText = FlutterI18n.translate(context, 'coin.stats.max_supply');
    final athText = FlutterI18n.translate(context, 'coin.stats.ath');
    final atlText = FlutterI18n.translate(context, 'coin.stats.atl');

    return widget.coin == null
        ? const ListSkeleton(size: 4, height: 90)
        : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            titleText,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Card(
          label: marketCapText,
          value: Format.currency(
            widget.coin!.marketCap,
            pattern: '$pricePrefix #,##0.00',
          ),
          complement: Percentage(
            value: widget.coin!.marketCapChangePercentage24h,
            style: Theme.of(context).textTheme.bodySmall, // corrigido aqui
          ),
          valueStyle: Theme.of(context).textTheme.titleMedium,
        ),
        Card(
          label: volumeText,
          value: Format.currency(
            widget.coin!.totalVolume,
            pattern: '$pricePrefix #,##0.00',
          ),
          valueStyle: Theme.of(context).textTheme.titleMedium,
        ),
        Card(
          label: marketDominanceText,
          value:
          "${Format.percentage(widget.coin!.marketDominance)} / ${Format.percentage(widget.coin!.socialDominance)}",
          valueStyle: Theme.of(context).textTheme.titleMedium,
        ),
        Card(
          label: circulatingSupplyText,
          value: Format.currency(
            widget.coin!.circulatingSupply,
            pattern: '#,##0',
          ),
          valueStyle: Theme.of(context).textTheme.titleMedium,
        ),
        Card(
          label: totalSupplyText,
          value: Format.currency(
            widget.coin!.totalSupply,
            pattern: '#,##0',
          ),
          valueStyle: Theme.of(context).textTheme.titleMedium,
        ),
        Card(
          label: maxSupplyText,
          value: Format.currency(
            widget.coin!.maxSupply,
            pattern: '#,##0',
          ),
          valueStyle: Theme.of(context).textTheme.titleMedium,
        ),
        Card(
          label: athText,
          value: Format.currency(
            widget.coin!.ath,
            pattern: '$pricePrefix #,##0.00####',
          ),
          complement: Percentage(
            value: widget.coin!.athChangePercentage,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          subValue: widget.coin!.athDate,
          valueStyle: Theme.of(context).textTheme.titleMedium,
        ),
        Card(
          label: atlText,
          value: Format.currency(
            widget.coin!.atl,
            pattern: '$pricePrefix #,##0.00####',
          ),
          complement: Percentage(
            value: widget.coin!.atlChangePercentage,
            style: Theme.of(context).textTheme.bodySmall, // corrigido aqui
          ),
          subValue: widget.coin!.atlDate,
          valueStyle: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}

class Card extends StatelessWidget {
  final String label;
  final String value;
  final Widget? complement;
  final String? subValue;
  final TextStyle? valueStyle;

  const Card({
    Key? key,
    required this.label,
    required this.value,
    this.complement,
    this.subValue,
    this.valueStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Só exibe o card se o valor não for "0"
    return value != '0'
        ? Container(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Theme.of(context).colorScheme.shadow),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.merge(valueStyle),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: complement,
              ),
            ],
          ),
          if (subValue != null)
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Text(
                subValue!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: const Divider(),
          )
        ],
      ),
    )
        : const SizedBox();
  }
}