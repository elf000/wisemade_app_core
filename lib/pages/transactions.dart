import 'package:flutter/material.dart';
import 'package:wisemade_app_core/pages/authenticated_page.dart';
import 'package:wisemade_app_core/widgets/coin/header.dart';
import 'package:wisemade_app_core/widgets/shared/appbar.dart';

import '../main.dart';
import '../models/my_coin.dart';
import '../widgets/my_accounts/coin_transactions_list.dart';
import '../widgets/my_accounts/my_coin_stats.dart';

class TransactionsPage extends AuthenticatedPage {
  final MyCoin coin;
  const TransactionsPage({super.key, required this.coin});

  @override
  AuthenticatedPageState<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends AuthenticatedPageState<TransactionsPage> {

  @override
  Widget render(BuildContext context) {
    mixpanel.track('Viewed Screen - Transactions');

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const CustomAppBar(preferredSize: Size.fromHeight(50)),
      body: SafeArea(
        child: CustomScrollView(slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                margin: const EdgeInsets.fromLTRB(20, 30, 0, 0),
                child: CoinHeader(coin: widget.coin)
              ),
              MyCoinStats(coin: widget.coin),
            ])
          ),
          CoinTransactionsList(coin: widget.coin),
        ])
      )
    );
  }
}
