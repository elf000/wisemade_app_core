import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../app_state.dart';
import '../../models/coin.dart';
import '../../pages/coin.dart'; // ← CORRIGIDO
import '../../utils/format.dart';
import '../shared/favorite_button.dart';
import '../shared/percentage.dart';

class CoinOfTheDay extends StatefulWidget {
  const CoinOfTheDay({super.key});

  @override
  State<CoinOfTheDay> createState() => _CoinOfTheDayState();
}

class _CoinOfTheDayState extends State<CoinOfTheDay> {
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
            if (coin != null) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CoinPage(myCoin: coin)) // ← COINPAGE CONFIRMADO
              );
            }
          },
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    titleText,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: (state.coinOfTheDayLoading || coin == null)
                      ? _buildShimmerPlaceholder()
                      : _buildCoinCard(context, coin, pricePrefix, last24HoursText, state),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade700,
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildCoinCard(BuildContext context, Coin coin, String pricePrefix, String last24HoursText, AppState state) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(coin.imageUrl, width: 64),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coin.symbol.toUpperCase(),
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.yellow[100]),
                  ),
                  Text(
                    coin.shortName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const Spacer(),
              FavoriteButton(
                coin: coin,
                isFavorite: state.favoriteCoins.any((c) => c.symbol == coin.symbol),
              )
            ],
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
                    Text(
                      Format.currency(coin.currentPrice, pattern: "$pricePrefix #,##0.00######"),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Percentage(value: coin.stats?['priceChangePercentage24h'] ?? 0),
              ],
            ),
          )
        ],
      ),
    );
  }
}