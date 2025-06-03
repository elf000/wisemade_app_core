import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import '../../models/coin.dart';
import '../../utils/format.dart';

class SmartContracts extends StatelessWidget {
  SmartContracts({
    super.key,
    required this.coin,
  });

  final Coin? coin;

  final Map<String, String> networksMap = {
    'binance-smart-chain' : 'BNB Smart Chain',
    'ethereum' : 'Ethereum',
    'polygon-pos' : 'Polygon',
    'optimism-ethereum' : 'Optimism',
    'arbitrum-one' : 'Arbitrum One',
    'arbitrum-nova' : 'Arbitrum Nova',
    'evmos' : 'Evmos',
    'osmosis' : 'Osmosis',
    'avalanche' : 'Avalanche',
    'solana' : 'Solana',
    'fantom' : 'Fantom',
  };

  final Map<String, String> networksImagesMap = {
    'binance-smart-chain' : 'https://assets.coingecko.com/coins/images/825/large/bnb-icon2_2x.png?1644979850',
    'ethereum' : 'https://assets.coingecko.com/coins/images/279/large/ethereum.png?1595348880',
    'polygon-pos' : 'https://assets.coingecko.com/coins/images/4713/large/matic-token-icon.png?1624446912',
    'optimism-ethereum' : 'https://assets.coingecko.com/coins/images/25244/large/Optimism.png?1660904599',
    'arbitrum-one' : 'https://assets.coingecko.com/coins/images/16547/large/photo_2023-03-29_21.47.00.jpeg?1680097630',
    'arbitrum-nova' : 'https://assets.coingecko.com/coins/images/16547/large/photo_2023-03-29_21.47.00.jpeg?1680097630',
    'evmos' : 'https://assets.coingecko.com/coins/images/24023/large/evmos.png?1653958927',
    'osmosis' : 'https://assets.coingecko.com/coins/images/16724/large/osmo.png?1632763885',
    'avalanche' : 'https://assets.coingecko.com/coins/images/12559/large/Avalanche_Circle_RedWhite_Trans.png?1670992574',
    'solana' : 'https://assets.coingecko.com/coins/images/4128/large/solana.png?1640133422',
    'fantom' : 'https://assets.coingecko.com/coins/images/4001/large/Fantom_round.png?1669652346',
  };

  @override
  Widget build(BuildContext context) {
    final addressCopiedText = FlutterI18n.translate(context, 'add_wallet.address_copied');

    return coin?.networks?.keys.where((network) => networksMap[network] != null).isNotEmpty ?? false ? Container(
      margin: const EdgeInsets.only(top:10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: Text('Smart contracts', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold))
          ),
          ...coin?.networks?.keys.where((network) => networksMap.containsKey(network)).map(
            (network) => Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              margin: const EdgeInsets.only(bottom: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        child: Row(
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: Image.network(networksImagesMap[network]!, width: 24)
                              ),
                              Text("${networksMap[network] ?? network}: "),
                              Text(Format.web3Address(coin?.networks?[network]), style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.shadow)),
                            ]
                        )
                    ),
                    SizedBox(
                        child: InkWell(
                          child: Icon(Icons.copy, size: 20, color: Theme.of(context).colorScheme.shadow),
                          onTap: () async {
                            await Clipboard.setData(ClipboardData(text: coin?.networks?[network]));

                            if(!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(addressCopiedText),
                                backgroundColor: const Color(0xff9CFF9A),
                                behavior: SnackBarBehavior.floating,
                                margin: const EdgeInsets.all(20),
                                elevation: 10,
                              ),
                            );
                          },
                        )
                    )
                  ]
              ),
            )
          ).toList() ?? []
        ]
      )
    ) : const SizedBox();
  }
}