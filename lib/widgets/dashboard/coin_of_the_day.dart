import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';
import 'package:wisemade_app_core/pages/coin.dart';
import 'package:wisemade_app_core/widgets/shared/percentage.dart';

import '../../app_state.dart';
import '../../models/coin.dart';
import '../../utils/format.dart';
import '../coin/add_coin_box.dart';
import '../shared/favorite_button.dart';

class CoinOfTheDay extends StatefulWidget {
  const CoinOfTheDay({
    Key? key,
  }) : super(key: key);

  @override
  State<CoinOfTheDay> createState() => _CoinOfTheDayState();
}

class _CoinOfTheDayState extends State<CoinOfTheDay> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final last24HoursText = FlutterI18n.translate(context, 'home.coin_of_the_day.last_24_hours');
    final titleText = FlutterI18n.translate(context, 'home.coin_of_the_day.title');

    return Consumer<AppState>(
      builder: (context, state, child) {
        final Coin? coin = state.coinOfTheDay;
        final pricePrefix = state.currentUser?.fiatPrefix ?? "\$";

        return InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CoinPage(myCoin: coin!)));
          },
          child: Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Text(titleText, style: TextStyle(fontWeight: FontWeight.bold, fontSize: Theme.of(context).textTheme.titleMedium?.fontSize)),
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: (state.coinOfTheDayLoading || state.coinOfTheDay == null)
                          ? const SkeletonLine(style: SkeletonLineStyle(height: 160))
                          : Container(
                            decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(5)),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(coin!.imageUrl, width: 64),
                                    ),
                                    Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 20),
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(coin!.symbol.toUpperCase(), style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.yellow[100])),
                                              Text(coin!.shortName, style: Theme.of(context).textTheme.titleLarge)
                                            ]
                                        )
                                    ),
                                    Expanded(
                                      child: Align(
                                          alignment: Alignment.topRight,
                                          child: FavoriteButton(coin: coin!, isFavorite: state.favoriteCoins.where((c) => c.symbol == coin.symbol).isNotEmpty)
                                      )
                                    )
                                  ]
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(right: 10),
                                            child: Text(last24HoursText, style: Theme.of(context).textTheme.bodySmall),
                                          ),
                                          Text(Format.currency(coin.currentPrice, pattern: "$pricePrefix #,##0.00######"), style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                                        ]
                                      ),
                                      Percentage(value: coin.stats?['priceChangePercentage24h'] ?? 0)
                                    ]
                                  )
                                )
                              ]
                            )
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