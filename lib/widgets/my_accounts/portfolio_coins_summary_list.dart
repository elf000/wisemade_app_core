import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:wisemade_app_core/widgets/shared/list_skeleton.dart';
import 'package:wisemade_app_core/widgets/shared/percentage.dart';

import '../../app_state.dart';
import '../../models/my_coin.dart';
import '../../pages/transactions.dart';
import '../../utils/format.dart';
import '../shared/list_item.dart';

class PortfolioCoinsSummaryList extends StatefulWidget {
  const PortfolioCoinsSummaryList({
    Key? key,
  }) : super(key: key);

  @override
  State<PortfolioCoinsSummaryList> createState() =>
      _PortfolioCoinsSummaryListState();
}

class _PortfolioCoinsSummaryListState
    extends State<PortfolioCoinsSummaryList> {
  late AppState appState;

  @override
  void initState() {
    super.initState();

    // Obtém o AppState sem reconstruir o widget ao mudar valores
    appState = Provider.of<AppState>(context, listen: false);

    // Solicita o carregamento da primeira página (o AppState já tem
    // coinsPagingController configurado via _initializePagingControllers())
    appState.coinsPagingController.refresh();
  }

  @override
  void dispose() {
    // Descarta o PagingController quando o widget for destruído
    appState.coinsPagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final titleText = FlutterI18n.translate(
      context,
      'portfolio.coins_summary.title',
    );
    final portfolioSyncingText = FlutterI18n.translate(
      context,
      'portfolio.coins_summary.portfolio_syncing',
    );
    final noCoinsFoundText = FlutterI18n.translate(
      context,
      'portfolio.coins_summary.no_coins_found',
    );

    return SliverPadding(
      padding: const EdgeInsets.all(20),
      sliver: MultiSliver(
        children: [
          Text(
            titleText,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white70,
            ),
          ),
          Consumer<AppState>(
            builder: (context, state, child) {
              // 1) Usa PagingListener para reagir ao state do PagingController
              return PagingListener<int, MyCoin>(
                controller: state.coinsPagingController,
                builder: (context, pagingState, fetchNextPage) {
                  // 2) PagedSliverList agora requer `state` e `fetchNextPage`
                  return PagedSliverList<int, MyCoin>(
                    // Gerencia o estado da paginação (lista de itens + metadados)
                    state: pagingState,
                    // Função disparada para buscar a próxima página
                    fetchNextPage: fetchNextPage,
                    builderDelegate: PagedChildBuilderDelegate<MyCoin>(
                      animateTransitions: true,
                      // Constrói cada item (MyCoin) na lista
                      itemBuilder: (context, coin, index) => _CoinCard(
                        coin: coin,
                      ),
                      // Indicador exibido durante o carregamento da primeira página
                      firstPageProgressIndicatorBuilder: (context) =>
                      const ListSkeleton(size: 6, height: 90),
                      // Indicador exibido caso não haja itens ou durante sync
                      noItemsFoundIndicatorBuilder: (context) {
                        final isSyncing = (state.selectedAssetHolder?.syncing ==
                            true);
                        if (state.selectedAssetHolder != null && isSyncing) {
                          return Center(
                            child: Text(
                              portfolioSyncingText,
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
                        return Center(
                          child: Text(noCoinsFoundText),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Card individual para exibir cada MyCoin
class _CoinCard extends StatelessWidget {
  final MyCoin coin;

  const _CoinCard({
    Key? key,
    required this.coin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final pricePrefix = state.currentUser?.fiatPrefix ?? "\$";

    return ListItem(
      height: 90,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TransactionsPage(coin: coin),
          ),
        );
      },
      children: [
        Row(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  coin.imageUrl,
                  width: 40,
                  height: 40,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  coin.shortName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  coin.formattedSymbol(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.shadow),
                ),
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
              child: Percentage(value: coin.profitPercentage!),
            ),
            Text(
              Format.currency(coin.balance!,
                  pattern: '$pricePrefix #,##0.00'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ],
    );
  }
}