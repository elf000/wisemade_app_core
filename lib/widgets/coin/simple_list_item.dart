import 'package:flutter/material.dart';

import '../../models/coin.dart';
import '../shared/favorite_button.dart';
import '../shared/list_item.dart';

class SimpleCoinsListItem extends StatefulWidget {
  final Coin coin;
  final Function onTap;
  final bool? favorite;

  const SimpleCoinsListItem({
    Key? key,
    required this.coin,
    required this.onTap,
    required this.favorite
  }) : super(key: key);

  @override
  State<SimpleCoinsListItem> createState() => _SimpleCoinsListItemState();
}

class _SimpleCoinsListItemState extends State<SimpleCoinsListItem> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListItem(
      height: 60,
      padding: 10,
      onTap: () {
        widget.onTap();
      },
      children: [
        Container(
            padding: const EdgeInsets.only(right: 20),
            child: FavoriteButton(coin: widget.coin, isFavorite: widget.favorite)
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            widget.coin.imageUrl ?? 'https://wisemade.io/favicon.ico',
            width: 48
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(
                widget.coin.shortName,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              )
          )
        )
      ]
    );
  }
}