import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

import '../../models/coin.dart';
import '../../pages/coin.dart';
import '../shared/favorite_button.dart';

class CoinHeader extends StatelessWidget {
  final Coin? coin;
  final bool inline;

  const CoinHeader({
    Key? key,
    required this.coin,
    this.inline = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = inline ? 40 : 80;
    ThemeData theme = Theme.of(context);

    List<Widget> coinInfo = [
      coin == null
        ? const SkeletonLine(style: SkeletonLineStyle(width: 130, height: 30))
        : Text(
          coin!.shortName,
          style: (inline ? theme.textTheme.titleLarge : theme.textTheme.titleMedium)?.copyWith(color: Colors.white),
        )
    ];

    if(!inline) {
      coinInfo.insert(
        0,
        coin == null
            ? const SkeletonLine(style: SkeletonLineStyle(width: 150, height: 30))
            : Text(
          coin!.formattedSymbol(),
          style: theme.textTheme.headlineMedium,
        )
      );
    }

    List<Widget> content = [
      Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
        child: coin == null
            ? SkeletonAvatar(style: SkeletonAvatarStyle(height: size, width: size))
            :  ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(coin!.imageUrl, width: size, height: size),
                )
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: coinInfo
      ),
      if(inline && coin!.marketCapRank != null) Expanded(
        flex: 1,
        child: Container(
          margin: const EdgeInsets.only(left: 10),
          child: Text(
            "#${coin!.marketCapRank}", style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey))
        )
      ),
      if(inline) Expanded(
        child: Align(
            alignment: Alignment.centerRight,
            child: FavoriteButton(coin: coin!)
        )
      )
    ];


    if(inline) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: content
      );
    } else {
      return InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CoinPage(myCoin: coin!)));
          },
          child: Row(
            children: [
              ...content,
              Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child:  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 20.0,
                  )
              )
            ]
          )
      );
    }
  }
}