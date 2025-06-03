import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wisemade_app_core/widgets/shared/coins_autocomplete/state.dart';
import 'package:wisemade_app_core/widgets/shared/exchanges_autocomplete/sheet.dart';
import 'package:wisemade_app_core/widgets/shared/exchanges_autocomplete/state.dart';

import '../../../main.dart';
import '../../../models/exchange.dart';
import '../list_item.dart';


class ExchangesAutocomplete extends StatefulWidget {
  final Function onSelect;

  const ExchangesAutocomplete({
    Key? key,
    required this.onSelect
  }) : super(key: key);

  @override
  State<ExchangesAutocomplete> createState() => _ExchangesAutocompleteState();
}


class _ExchangesAutocompleteState extends State<ExchangesAutocomplete> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ExchangesAutocompleteState, CoinsAutocompleteState>(
        builder: (context, exchangesState, coinsState, child) {
          return InkWell(
            onTap: () {
              mixpanel.track('Clicked on [Select an Exchange]');

              coinsState.clearSelectedCoin();
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) => Wrap(
                    children: [
                      Sheet(onSelect: (Exchange exchange) {
                        widget.onSelect(exchange);
                      })
                    ],
                  )
              );
            },
            child: (() {
              if(exchangesState.selectedExchange == null) {
                return ListItem(
                    height: 60,
                    padding: 10,
                    margin: 0,
                    children: [
                      Container(
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Text(
                            'Selecione uma corretora',
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
                              child: Image.network(exchangesState.selectedExchange!.imageUrl!, width: 32),
                            ),
                            Text(
                              exchangesState.selectedExchange!.name!,
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