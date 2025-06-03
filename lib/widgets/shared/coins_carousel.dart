import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wisemade_app_core/app_state.dart';
import 'package:wisemade_app_core/pages/coin.dart';

import '../../models/coin.dart';
import '../../utils/format.dart';
import '../coin/add_coin_box.dart';
import '../shared/carousel_skeleton.dart';

class CoinsCarousel extends StatefulWidget {
  final List<Coin> coins;
  final bool loading;
  final Widget title;

  const CoinsCarousel({
    Key? key,
    required this.coins,
    required this.loading,
    required this.title
  }) : super(key: key);

  @override
  State<CoinsCarousel> createState() => _CoinsCarouselState();
}

class _CoinsCarouselState extends State<CoinsCarousel> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.loading || widget.coins.isNotEmpty) ? Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.title,
          Container(
            height: 140,
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: widget.loading
                ? const CarouselSkeleton(length: 10, height: 120, width: 180)
                : ListView(
                scrollDirection: Axis.horizontal,
                children: widget.coins.map<Widget>((coin) => Card(coin: coin)).toList()
            ),
          ),
        ]
      )
    ) : const SizedBox();
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
    AppState state = Provider.of<AppState>(context);
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
                Image.network(coin!.imageUrl, width: 48, height: 48),
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Format.currency(coin!.currentPriceBrl, pattern: '$pricePrefix #,##0.00###'),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
                )
              ],
            )
          ]
        )
      ) : const AddCoinBox()
    ) ;

  }
}