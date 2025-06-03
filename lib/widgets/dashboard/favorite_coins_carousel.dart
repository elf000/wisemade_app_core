import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:wisemade_app_core/pages/coin.dart';

import '../../app_state.dart';
import '../../models/coin.dart';
import '../../utils/format.dart';
import '../coin/add_coin_box.dart';
import '../shared/carousel_skeleton.dart';
import '../shared/percentage.dart';

class FavoriteCoinsCarousel extends StatefulWidget {
  const FavoriteCoinsCarousel({
    Key? key,
  }) : super(key: key);

  @override
  State<FavoriteCoinsCarousel> createState() => _FavoriteCoinsCarouselState();
}

class _FavoriteCoinsCarouselState extends State<FavoriteCoinsCarousel> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, child) {
        final List<Coin> coins = state.favoriteCoins;
        final titleText = FlutterI18n.translate(context, 'home.favorite_coins_carousel.title');

        return (state.favoriteCoinsLoading || coins.isNotEmpty) ? Container(
          padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titleText, style: TextStyle(fontWeight: FontWeight.bold, fontSize: Theme.of(context).textTheme.titleMedium?.fontSize)),
              Container(
                height: 220,
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: state.favoriteCoinsLoading
                    ? const CarouselSkeleton(length: 10, height: 220, width: 190)
                    : ListView(
                    scrollDirection: Axis.horizontal,
                    children: coins.map<Widget>((coin) => Card(coin: coin)).toList()
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
        width: 190,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: Theme.of(context).cardColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(coin!.imageUrl, width: 48, height: 48),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(coin!.symbol.toUpperCase(), style: Theme.of(context).textTheme.headlineSmall),
                  Text(
                      coin!.shortName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.shadow)
                  )
                ]
              )
            ),
            Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    Format.currency(coin!.stats?['currentPrice'], pattern: "$pricePrefix #,##0.00######"),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
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