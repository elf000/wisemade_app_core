import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:wisemade_app_core/widgets/coin/statistic_bar.dart';


import '../../models/coin.dart';

class StatisticBars extends StatelessWidget {
  final Coin? coin;

  const StatisticBars({
    super.key,
    required this.coin,
  });

  @override
  Widget build(BuildContext context) {
    final bearishText = FlutterI18n.translate(context, 'coin.statistic_bars.bearish');
    final bullishText = FlutterI18n.translate(context, 'coin.statistic_bars.bullish');
    final sentimentText = FlutterI18n.translate(context, 'coin.statistic_bars.sentiment');
    final lowText = FlutterI18n.translate(context, 'coin.statistic_bars.low_performance');
    final highText = FlutterI18n.translate(context, 'coin.statistic_bars.high_performance');
    final performanceText = FlutterI18n.translate(context, 'coin.statistic_bars.performance');
    final lowVolatilityText = FlutterI18n.translate(context, 'coin.statistic_bars.low_volatility');
    final highVolatilityText = FlutterI18n.translate(context, 'coin.statistic_bars.high_volatility');
    final volatilityText = FlutterI18n.translate(context, 'coin.statistic_bars.volatility');

    return coin != null ? Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: StatisticBar(value: coin?.stats?['averageSentiment'], leading: bearishText, trailing: bullishText, label: sentimentText),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: StatisticBar(value: coin?.stats?['coinStrength'], leading: lowText, trailing: highText, label: performanceText),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: StatisticBar(value: coin?.stats?['volatility'], leading: lowVolatilityText, trailing: highVolatilityText, label: volatilityText, fixedColor: true),
        ),
      ]
    ) : const SizedBox();
  }
}