
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wisemade_app_core/app_state.dart';
import 'package:wisemade_app_core/widgets/shared/favorite_button.dart';
import 'package:wisemade_app_core/widgets/shared/percentage.dart';

import '../../models/coin.dart';
import '../../utils/format.dart';
import 'list_item.dart';

class CoinListItem extends StatefulWidget {
  final Coin coin;
  final bool? favorite;
  final Function onTap;

  const CoinListItem({
    Key? key,
    required this.coin,
    required this.onTap,
    this.favorite
  }) : super(key: key);

  @override
  State<CoinListItem> createState() => _CoinListItemState();
}

class _CoinListItemState extends State<CoinListItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppState state = Provider.of<AppState>(context);
    final pricePrefix = state.currentUser?.fiatPrefix ?? "\$";

    return ListItem(
        height: 70,
        padding: 12,
        onTap: () {
          widget.onTap();
        },
        children: [
          if(widget.favorite != null) Container(
            padding: const EdgeInsets.only(right: 20),
            child: FavoriteButton(coin: widget.coin, isFavorite: widget.favorite ?? false)
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3.0),
              child: Image.network(widget.coin.imageUrl, width: 35, height: 35),
            )
          ),
          Expanded(
            flex: 1,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.coin.formattedSymbol(),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    widget.coin.shortName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.shadow),
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ]
            )
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: Percentage(value: widget.coin.stats?['priceChangePercentage24h'], style: Theme.of(context).textTheme.bodySmall),
                ),
                Text(Format.currency(widget.coin.stats?['currentPrice']!, pattern: "$pricePrefix #,##0.00######"), style: Theme.of(context).textTheme.bodyLarge),
              ]
          ),
        ]
    );
  }
}