import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';

import '../../../app_state.dart';
import '../../../models/coin.dart';
import '../../../models/exchange.dart';
import '../../coin/simple_list_item.dart';
import '../list_shimmer.dart';

class Sheet extends StatefulWidget {
  final Exchange? exchange;
  final Function onSelect;

  const Sheet({
    Key? key,
    required this.onSelect,
    this.exchange,
  }) : super(key: key);

  @override
  State<Sheet> createState() => _SheetState();
}

class _SheetState extends State<Sheet> {
  late AppState appState;
  bool alreadyLoaded = false;

  @override
  void initState() {
    super.initState();

    appState = AppState(context: context);

    // Dispara a busca de moedas (retorno void)
    appState.buscarCoins(exchange: widget.exchange);

    // Aguarda apenas o Future<void> de getFavoriteCoins()
    appState.getFavoriteCoins().then((_) {
      setState(() {
        alreadyLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final labelText =
    FlutterI18n.translate(context, 'add_transaction.search.coin.label');
    final hintText =
    FlutterI18n.translate(context, 'add_transaction.search.coin.hint');

    return ChangeNotifierProvider<AppState>.value(
      value: appState,
      child: Consumer<AppState>(
        builder: (context, state, child) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          height: MediaQuery.of(context).size.height * 0.8,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                scrolledUnderElevation: 0,
                pinned: true,
                toolbarHeight: 80,
                backgroundColor: Theme.of(context).colorScheme.surface,
                automaticallyImplyLeading: false,
                title: TextFormField(
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  cursorColor: Theme.of(context).primaryColor,
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white24),
                    ),
                    border: const OutlineInputBorder(),
                    labelText: labelText,
                    hintText: hintText,
                  ),
                  onChanged: (String query) {
                    if (query.isEmpty || query.length >= 3) {
                      state.buscarCoins(
                        exchange: widget.exchange,
                        query: query,
                      );
                    }
                  },
                ),
              ),

              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    if (!alreadyLoaded)
                      const ListSkeleton(size: 8)
                    else
                      Column(
                        children: state.searchedCoins
                            .map(
                              (coin) => SimpleCoinsListItem(
                            coin: coin,
                            onTap: () {
                              widget.onSelect(coin);
                            },
                            favorite: state.favoriteCoins
                                .where((c) => c.symbol == coin.symbol)
                                .isNotEmpty,
                          ),
                        )
                            .toList(),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}