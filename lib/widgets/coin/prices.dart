import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wisemade_app_core/app_state.dart';
import 'package:wisemade_app_core/utils/format.dart';
import 'package:wisemade_app_core/widgets/shared/percentage.dart';

import '../../models/coin.dart';
import '../shared/text_skeleton.dart';

class CoinPrices extends StatelessWidget {
  final Coin? coin;

  const CoinPrices({
    Key? key,
    required this.coin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppState state = Provider.of<AppState>(context);

    final primaryPrice = coin?.currentPrice;
    final primaryPricePrefix = state.currentUser?.fiatPrefix ?? "\$";

    final secondaryPrice = state.currentUser?.fiatSymbol != 'usd' ? coin?.currentPriceUsd : null;
    const secondaryPricePrefix = "\$";

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              TextSkeleton(
                primaryPrice,
                ready: coin != null,
                height: 40,
                width: 250,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                formatter: (text) => Format.currency(text, pattern: "$primaryPricePrefix #,##0.00######"),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: coin != null ? Percentage(
                  value: coin!.priceChangePercentage24h,
                  style: Theme.of(context).textTheme.titleLarge,
                ) : null
              )
            ]
          ),
          if(coin?.symbol != 'btc') TextSkeleton(
            coin?.currentPriceBtc,
            ready: coin != null,
            height: 40,
            width: 150,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white70),
            formatter: (text) => Format.currency(text, pattern: "#,##0.00####### BTC"),
          ),
          if(secondaryPrice != null) TextSkeleton(
            secondaryPrice,
            ready: coin != null,
            height: 40,
            width: 120,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white70),
            formatter: (text) => Format.currency(text, pattern: "$secondaryPricePrefix #,##0.00########"),
          )
        ]
    );
  }
}