import 'package:flutter/material.dart';

import '../../../models/exchange.dart';
import '../list_item.dart';

class Item extends StatefulWidget {
  final Exchange exchange;
  final Function onTap;

  const Item({
    Key? key,
    required this.exchange,
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
        widget.onTap(widget.exchange);
      },
      children: [
        Row(
          children: [
            Image.network(
              widget.exchange.imageUrl ?? 'https://wisemade.io/favicon.ico',
              width: 48
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.exchange.name,
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