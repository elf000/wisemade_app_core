import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../app_state.dart';
import '../main.dart';
import '../models/coin.dart';
import '../models/exchange.dart';
import '../widgets/coin/simple_list_item.dart';
import '../widgets/shared/appbar.dart';
import '../widgets/shared/list_skeleton.dart';
import 'authenticated_page.dart';
import 'coin.dart';

class CoinsSearchPage extends AuthenticatedPage {
  final Map<String, dynamic>? filters;
  final Exchange? exchange;

  const CoinsSearchPage({
    this.filters,
    this.exchange,
    super.key,
  });

  @override
  AuthenticatedPageState<CoinsSearchPage> createState() => _MarketCoinsPageState();
}

class _MarketCoinsPageState extends AuthenticatedPageState<CoinsSearchPage> {
  late final AppState appState;

  @override
  void initState() {
    super.initState();

    // 1) Obtém a instância do AppState (sem listen: não queremos rebuild automático ao mudar AppState)
    appState = Provider.of<AppState>(context, listen: false);

    // 2) Carrega imediatamente a primeira página (com query = vazio)
    appState.buscarCoins(
      exchange: widget.exchange,
      category: widget.filters?['category'] as String?,
      query: '',
    );
  }

  @override
  Widget render(BuildContext context) {
    // Rastreia analytics ao montar a tela
    mixpanel.track(
      'Viewed Screen - Search',
      properties: {'filters': widget.filters},
    );

    final noCoinText =
    FlutterI18n.translate(context, 'portfolio.no_coins_found');
    final searchHintText = FlutterI18n.translate(
        context, 'add_transaction.search.coin.hint');

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: CustomAppBar(
        title: widget.filters?['category'] as String?,
        preferredSize: const Size.fromHeight(40),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Consumer<AppState>(
              builder: (context, state, child) {
                return CustomScrollView(
                  slivers: [
                    MultiSliver(
                      children: [
                        // Campo de texto para buscar moedas
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          child: TextFormField(
                            autocorrect: false,
                            keyboardType: TextInputType.text,
                            cursorColor: Theme.of(context).primaryColor,
                            decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white24),
                              ),
                              border: const OutlineInputBorder(),
                              hintText: searchHintText,
                            ),
                            onChanged: (String query) {
                              // Só dispara se vazio ou >= 3 caracteres
                              if (query.isEmpty || query.length >= 3) {
                                state.buscarCoins(
                                  exchange: widget.exchange,
                                  category:
                                  widget.filters?['category'] as String?,
                                  query: query,
                                );
                              }
                            },
                          ),
                        ),

                        // Lista paginada das moedas usando PagingListener + PagedSliverList
                        PagingListener<int, Coin>(
                          controller: state.searchedCoinsPagingController,
                          builder: (context, pagingState, fetchNextPage) {
                            return PagedSliverList<int, Coin>(
                              state: pagingState,
                              fetchNextPage: fetchNextPage,
                              builderDelegate:
                              PagedChildBuilderDelegate<Coin>(
                                animateTransitions: true,
                                itemBuilder: (context, item, index) =>
                                    SimpleCoinsListItem(
                                      coin: item,
                                      favorite: state.favoriteCoins!
                                          .any((c) => c.symbol == item.symbol),
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CoinPage(myCoin: item),
                                          ),
                                        );
                                      },
                                    ),
                                firstPageProgressIndicatorBuilder:
                                    (context) =>
                                const ListSkeleton(size: 10, height: 60),
                                noItemsFoundIndicatorBuilder: (context) =>
                                    Center(child: Text(noCoinText)),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}