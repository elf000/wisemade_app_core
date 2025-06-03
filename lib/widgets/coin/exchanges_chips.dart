import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wisemade_app_core/widgets/shared/custom_chip.dart';

import '../../models/coin.dart';
import '../../utils/format.dart';

class ExchangesChips extends StatelessWidget {
  const ExchangesChips({
    super.key,
    required this.coin
  });

  final Coin? coin;

  @override
  Widget build(BuildContext context) {
    final titleText = FlutterI18n.translate(context, 'coin.markets');
    final errorText = FlutterI18n.translate(context, 'shared.generic_error');

    return (coin?.exchanges?.isNotEmpty ?? false) ? Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: Text(titleText, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold))
          ),
          Wrap(
            spacing: 10,
            children: coin?.exchanges?.where((exchange) => exchange['url'] != null && exchange['imageUrl'] != null)?.take(20).map(
              (exchange) => CustomChip(
                side: BorderSide(color: Theme.of(context).cardColor, width: 1),
                avatar: ClipRRect(
                  borderRadius: BorderRadius.circular(2.0),
                  child: Image.network(exchange['imageUrl']),
                ),
                backgroundColor: Theme.of(context).cardColor,
                label: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(exchange['name']),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: const Icon(Icons.open_in_new, size: 18),
                    )
                  ]),
                onSelected: (_) async {
                  Uri url = Uri.parse(exchange['url']);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    if(!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(errorText),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.all(20),
                        elevation: 10,
                      ),
                    );
                  }
                },
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              )
            ).toList() ?? []
          )
        ]
      )
    ) : const SizedBox();
  }
}