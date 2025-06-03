import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:skeletons/skeletons.dart';

import '../../models/coin.dart';
import '../../pages/webview_screen.dart';

class CoinDescription extends StatefulWidget {
  final Coin? coin;

  const CoinDescription({
    Key? key,
    required this.coin,
  }) : super(key: key);

  @override
  State<CoinDescription> createState() => _CoinDescriptionState();
}

class _CoinDescriptionState extends State<CoinDescription> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final titleText = FlutterI18n.translate(context, 'coin.title', translationParams: { 'coinName' : widget.coin?.shortName ?? '' });

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
      child: widget.coin == null
        ? const SkeletonLine(style: SkeletonLineStyle(height: 400))
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.coin?.description != null ? [
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Text(titleText, style: Theme.of(context).textTheme.headlineSmall),
            ),
            Html(
                data: widget.coin!.description,
                style: { 'a' : Style( color: Theme.of(context).colorScheme.outline), '*' : Style(fontSize: FontSize(Theme.of(context).textTheme.titleMedium?.fontSize ?? 16))  },
                onLinkTap: (url, renderContext, attributes) => {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => WebviewScreen(url: url ?? ''))
                  )
                },
              )
        ] : []
      )
    );
  }
}