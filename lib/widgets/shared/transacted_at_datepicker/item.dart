
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../models/coin.dart';
import '../list_item.dart';

class Item extends StatefulWidget {
  final Coin coin;
  final Function onTap;

  const Item({
    Key? key,
    required this.coin,
    required this.onTap
  }) : super(key: key);

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {


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
        mixpanel.track('Clicked on [Select Transaction Date]');
        widget.onTap(widget.coin);
      },
      children: [
        Row(
          children: [
            Image.network(
              widget.coin.imageUrl ?? 'https://wisemade.io/favicon.ico',
              width: 48
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.coin.shortName,
                    style: Theme.of(context).textTheme.titleLarge,
                  )
                ]
              )
            )
          ]
        ),
      ]
    );
  }
}