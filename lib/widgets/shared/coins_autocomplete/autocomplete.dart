import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:wisemade_app_core/widgets/shared/coins_autocomplete/sheet.dart';
import 'package:wisemade_app_core/widgets/shared/coins_autocomplete/state.dart';

import '../../../app_state.dart';
import '../../../models/coin.dart';
import '../../../models/exchange.dart';
import '../list_item.dart';


class CoinsAutocomplete extends StatefulWidget {
  final Exchange? exchange;
  final Function onSelect;

  const CoinsAutocomplete({
    Key? key,
    required this.exchange,
    required this.onSelect
  }) : super(key: key);

  @override
  State<CoinsAutocomplete> createState() => _CoinsAutocompleteState();
}


class _CoinsAutocompleteState extends State<CoinsAutocomplete> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectCoinText = FlutterI18n.translate(context, 'add_transaction.select_coin');

    return Consumer2<CoinsAutocompleteState, AppState>(
        builder: (context, coinsState, appState, child) {
          return InkWell(
              onTap: () => {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) => Wrap(
                      children: [
                        Sheet(
                            exchange: widget.exchange,
                            onSelect: (Coin coin) {
                              widget.onSelect(coin);
                            }
                        )
                      ],
                    )
                )
              },
              child: (() {
                if(coinsState.selectedCoin == null) {
                  return ListItem(
                      height: 60,
                      padding: 10,
                      margin: 0,
                      children: [
                        Container(
                            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Text(
                              selectCoinText,
                              style: Theme.of(context).textTheme.titleMedium,
                            )
                        ),
                        Container(
                            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: const Icon(Icons.arrow_forward_ios, size: 16)
                        )
                      ]
                  );
                } else {
                  return ListItem(
                      height: 60,
                      padding: 10,
                      margin: 0,
                      children: [
                        Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.fromLTRB(8, 0, 16, 0),
                                child: Image.network(coinsState.selectedCoin!.imageUrl!, width: 32),
                              ),
                              Text(
                                coinsState.selectedCoin!.shortName!,
                                style: Theme.of(context).textTheme.titleMedium,
                              )
                            ]
                        ),
                        Container(
                            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: const Icon(Icons.arrow_forward_ios, size: 16)
                        )
                      ]
                  );
                }
              }())
          );
        }
    );
  }
}