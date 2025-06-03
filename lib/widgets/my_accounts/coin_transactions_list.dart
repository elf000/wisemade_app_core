// lib/widgets/my_accounts/coin_transactions_list.dart

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:wisemade_app_core/widgets/shared/list_skeleton.dart';

import '../../app_state.dart';
import '../../models/my_coin.dart';         // ← ADICIONE ESTA LINHA
import '../../models/transaction.dart';
import '../../utils/format.dart';
import '../shared/list_item.dart';

class CoinTransactionsList extends StatefulWidget {
  final MyCoin coin;

  const CoinTransactionsList({
    Key? key,
    required this.coin,
  }) : super(key: key);

  @override
  State<CoinTransactionsList> createState() => _CoinTransactionsListState();
}

class _CoinTransactionsListState extends State<CoinTransactionsList> {
  late AppState appState;

  @override
  void initState() {
    super.initState();
    appState = Provider.of<AppState>(context, listen: false);

    // Inicia a paginação de transações para a moeda passada
    appState.carregarTransacoesParaCoin(widget.coin);
  }

  @override
  Widget build(BuildContext context) {
    final titleText = FlutterI18n.translate(context, 'transactions.title');
    final transactionExclusionSuccessText =
    FlutterI18n.translate(context, 'transactions.exclusion_success');
    final noTransactionsFoundText =
    FlutterI18n.translate(context, 'transactions.no_transactions_found');

    return SliverPadding(
      padding: const EdgeInsets.all(20),
      sliver: MultiSliver(
        children: [
          Text(
            titleText,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Colors.white70),
          ),
          Consumer<AppState>(
            builder: (context, state, child) {
              return PagingListener<int, Transaction>(
                controller: state.transactionsPagingController,
                builder: (context, pagingState, fetchNextPage) {
                  return PagedSliverList<int, Transaction>(
                    state: pagingState,
                    fetchNextPage: fetchNextPage,
                    builderDelegate: PagedChildBuilderDelegate<Transaction>(
                      animateTransitions: true,
                      itemBuilder: (context, item, index) =>
                          TransactionCard(
                            transaction: item,
                            onDismissed: () async {
                              appState.context = context;

                              // “Refresh” em vez de criar nova instância
                              state.transactionsPagingController.refresh();
                              await appState.deleteTransaction(item);

                              if (appState.coinTransactionsCount == 0) {
                                appState.tabController.jumpToTab(0);
                              }

                              ScaffoldMessenger.of(appState.context!).showSnackBar(
                                SnackBar(
                                  content:
                                  Text(transactionExclusionSuccessText),
                                  backgroundColor: const Color(0xff9CFF9A),
                                  behavior: SnackBarBehavior.floating,
                                  margin: const EdgeInsets.all(20),
                                  elevation: 10,
                                ),
                              );
                            },
                          ),
                      firstPageProgressIndicatorBuilder: (context) =>
                      const ListSkeleton(size: 6, height: 90),
                      noItemsFoundIndicatorBuilder: (context) =>
                          Center(child: Text(noTransactionsFoundText)),
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

/// Renomeamos a classe “Card” para evitar conflito com o Card do Material
class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final Future<void> Function() onDismissed;

  const TransactionCard({
    Key? key,
    required this.transaction,
    required this.onDismissed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final pricePrefix = state.currentUser?.fiatPrefix ?? "\$";

    return ListItem(
      height: 60,
      padding: 10,
      key: Key(transaction.id.toString()),
      onDismissed: () {
        onDismissed();
      },
      children: [
        Row(
          children: [
            Icon(
              transaction.isPositive()
                  ? Icons.arrow_downward
                  : Icons.arrow_upward,
              color: transaction.isPositive()
                  ? Colors.lightGreenAccent
                  : Colors.red,
              size: 20,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      Format.currency(
                        transaction.totalSpent(),
                        pattern: '$pricePrefix #,##0.00',
                      ),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    if (transaction.transactionType == 'fee')
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        padding:
                        const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.red,
                        ),
                        child: Text(
                          'FEE',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: Colors.white70),
                        ),
                      ),
                  ],
                ),
                Text(
                  DateFormat('dd/MM/yyyy HH:mm')
                      .format(transaction.transactedAt),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Format.currency(
                transaction.price,
                pattern: '$pricePrefix #,##0.00',
              ),
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              transaction.formattedAmount(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }
}