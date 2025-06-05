import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:wisemade_app_core/widgets/coin/simple_list_item.dart';
import 'package:wisemade_app_core/widgets/shared/list_shimmer.dart';

import '../../models/coin.dart';
import '../../pages/coin.dart';

class SimpleCoinList extends StatelessWidget {
  final PagingController<int, Coin> pagingController;
  final List<Coin>? favorites;
  final String? title;

  const SimpleCoinList({
    Key? key,
    required this.pagingController,
    this.favorites,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final noCoinText =
    FlutterI18n.translate(context, 'portfolio.no_coins_found');

    return PagingListener<int, Coin>(
      controller: pagingController,
      builder: (context, state, fetchNextPage) {
        return PagedListView<int, Coin>(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          state: state,               // NOVO: estado gerenciado pelo PagingListener
          fetchNextPage: fetchNextPage, // NOVO: função para buscar a próxima página
          builderDelegate: PagedChildBuilderDelegate<Coin>(
            animateTransitions: true,
            itemBuilder: (context, item, index) {
              return SimpleCoinsListItem(
                coin: item,
                favorite:
                favorites?.any((c) => c.symbol == item.symbol) ?? false,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CoinPage(myCoin: item),
                    ),
                  );
                },
              );
            },
            firstPageProgressIndicatorBuilder: (context) =>
            const ListSkeleton(size: 5, height: 60),
            noItemsFoundIndicatorBuilder: (context) =>
                Center(child: Text(noCoinText)),
          ),
        );
      },
    );
  }
}
