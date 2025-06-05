import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart'; // Usando shimmer correto

import '../../models/coin.dart';
import '../../pages/coin.dart';
import '../shared/favorite_button.dart';

class CoinHeader extends StatelessWidget {
  final Coin? coin;
  final bool inline;

  const CoinHeader({
    super.key, // ✅ correção do parâmetro key
    required this.coin,
    this.inline = false,
  });

  Widget _shimmerLine({double width = 130, double height = 30}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[700]!,
      child: Container(
        width: width,
        height: height,
        color: Colors.grey[850],
      ),
    );
  }

  Widget _shimmerAvatar(double size) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[700]!,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double size = inline ? 40 : 80;
    final theme = Theme.of(context);

    final List<Widget> coinInfo = [
      coin == null
          ? _shimmerLine(width: 130, height: 30)
          : Text(
        coin!.shortName,
        style: (inline
            ? theme.textTheme.titleLarge
            : theme.textTheme.titleMedium)
            ?.copyWith(color: Colors.white),
      )
    ];

    if (!inline) {
      coinInfo.insert(
        0,
        coin == null
            ? _shimmerLine(width: 150, height: 30)
            : Text(
          coin!.formattedSymbol(),
          style: theme.textTheme.headlineMedium,
        ),
      );
    }

    final List<Widget> content = [
      Container(
        margin: const EdgeInsets.only(right: 10),
        child: coin == null
            ? _shimmerAvatar(size)
            : ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            coin!.imageUrl,
            width: size,
            height: size,
          ),
        ),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: coinInfo,
      ),
      if (inline && coin?.marketCapRank != null)
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 10),
            child: Text(
              "#${coin!.marketCapRank}",
              style: theme.textTheme.titleLarge?.copyWith(color: Colors.grey),
            ),
          ),
        ),
      if (inline)
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: coin != null ? FavoriteButton(coin: coin!) : const SizedBox.shrink(),
          ),
        ),
    ];

    if (inline) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: content,
      );
    } else {
      return InkWell(
        onTap: () {
          if (coin != null) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => CoinPage(myCoin: coin!)),
            );
          }
        },
        child: Row(
          children: [
            ...content,
            const SizedBox(width: 20),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 20.0,
            ),
          ],
        ),
      );
    }
  }
}