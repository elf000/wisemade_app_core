import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_state.dart';
import '../../models/coin.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({
    super.key,
    required this.coin,
    this.isFavorite,
  });

  final Coin coin;
  final bool? isFavorite;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, child) => StarButton(
        iconColor: Theme.of(context).colorScheme.secondary,
        iconSize: 40,
        isStarred: widget.isFavorite ?? state.favoriteCoins.where((c) => c.symbol == widget.coin.symbol).isNotEmpty,
        valueChanged: (isStarred) {
          state.toggleFavorite(widget.coin);
        },
      )
    );
  }
}