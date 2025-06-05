import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:shimmer/shimmer.dart'; // ← Correto para shimmer

import '../../models/coin.dart';
import '../../pages/webview_screen.dart';

class CoinDescription extends StatefulWidget {
  const CoinDescription({
    super.key,
    required this.coin,
  });

  final Coin? coin;

  @override
  State<CoinDescription> createState() => _CoinDescriptionState();
}

class _CoinDescriptionState extends State<CoinDescription> {
  @override
  Widget build(BuildContext context) {
    final titleText = FlutterI18n.translate(
      context,
      'coin.title',
      translationParams: {'coinName': widget.coin?.shortName ?? ''},
    );

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
      child: widget.coin == null
          ? Shimmer.fromColors(
        baseColor: const Color(0xFF24213F),
        highlightColor: const Color(0xFF292845),
        child: Container(
          width: double.infinity,
          height: 400,
          decoration: BoxDecoration(
            color: const Color(0xFF24213F),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.coin?.description != null
            ? [
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Text(
              titleText,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Html(
            data: widget.coin!.description,
            style: {
              'a': Style(
                  color: Theme.of(context).colorScheme.outline),
              '*': Style(
                fontSize: FontSize(
                  Theme.of(context).textTheme.titleMedium?.fontSize ?? 16,
                ),
              ),
            },
            onLinkTap: (url, _, __) {
              if (url != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => WebviewScreen(url: url),
                  ),
                );
              }
            },
          )
        ]
            : [],
      ),
    );
  }
}