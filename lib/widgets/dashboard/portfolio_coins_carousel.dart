import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:wisemade_app_core/models/coin.dart';
import 'package:wisemade_app_core/pages/coin.dart';

import '../../app_state.dart';
import '../../utils/format.dart';
import '../coin/add_coin_box.dart';
import '../shared/carousel_skeleton.dart';
import '../shared/percentage.dart';

class PortfolioCoinsCarousel extends StatefulWidget {
  const PortfolioCoinsCarousel({
    Key? key,
  }) : super(key: key);

  @override
  State<PortfolioCoinsCarousel> createState() => _PortfolioCoinsCarouselState();
}

class _PortfolioCoinsCarouselState extends State<PortfolioCoinsCarousel> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, child) {
        final List<Coin> coins = state.portfolioCoins;
        final titleText = FlutterI18n.translate(context, 'home.coins_carousel.title');

        return (state.portfolioCoinsLoading || coins.isNotEmpty) ? Container(
          padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titleText, style: TextStyle(fontWeight: FontWeight.bold, fontSize: Theme.of(context).textTheme.titleMedium?.fontSize)),
              Container(
                height: 160,
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: state.portfolioCoinsLoading
                    ? const CarouselSkeleton(length: 10, height: 160, width: 240)
                    : ListView(
                    scrollDirection: Axis.horizontal,
                    children: [...coins, null].map<Widget>((coin) => Card(coin: coin)).toList()
                ),
              ),
            ]
          )
        ) : const SizedBox();
      }
    );
  }
}

class Card extends StatelessWidget {
  final Coin? coin;

  const Card({
    Key? key,
    required this.coin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppState state = Provider.of<AppState>(context, listen: false);
    final pricePrefix = state.currentUser?.fiatPrefix ?? "\$";

    return InkWell(
      onTap: () => {
        if(coin != null) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CoinPage(myCoin: coin!)))
        }
      },
      child: coin != null ? Container(
        width: 240,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: Theme.of(context).cardColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(coin!.symbol.toUpperCase(), style: Theme.of(context).textTheme.headlineSmall),
                      Text(
                        coin!.shortName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.shadow)
                      ),
                    ]
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(coin!.imageUrl, width: 48, height: 48),
                )
              ]
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    Format.currency(coin!.stats?['currentPrice'] ?? 0, pattern: "$pricePrefix #,##0.00######"),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
                  ),
                ),
                Percentage(value: coin!.stats?['priceChangePercentage24h'])
              ]
            )
          ]
        )
      ) : const AddCoinBox()
    ) ;

  }
}