
import 'package:flutter/material.dart';
import 'package:wisemade_app_core/widgets/shared/list_skeleton.dart';

import '../../models/coin.dart';
import '../../pages/coin.dart';
import 'coin_list_item.dart';

class CoinList extends StatelessWidget {
  final List<Coin> coins;
  final List<Coin>? favorites;
  final String? title;

  const CoinList({
    Key? key,
    required this.coins,
    this.favorites,
    this.title
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(title != null) Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Text(title!, style: Theme.of(context).textTheme.titleLarge)
        ),
        if(coins.isNotEmpty) Column(
          children: coins
              .where((coin) => coin.stats != null && coin.stats?['currentPrice'] != null)
              .map<Widget>((coin) => CoinListItem(
                coin: coin,
                favorite: favorites?.where((c) => c.symbol == coin.symbol).isNotEmpty,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => CoinPage(myCoin: coin!)));
                })).toList()
        ) else const ListSkeleton(size: 10, height: 65)
      ]
    );
  }
}