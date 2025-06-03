import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class SupportedNetworks extends StatelessWidget {
  const SupportedNetworks({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, String> networksImagesMap = {
      'bitcoin' : 'https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1696501400',
      'ethereum' : 'https://assets.coingecko.com/asset_platforms/images/279/large/ethereum.png?1694050123',
      'binance-smart-chain' : 'https://assets.coingecko.com/coins/images/825/large/bnb-icon2_2x.png?1644979850',
      'polygon-pos' : 'https://assets.coingecko.com/coins/images/4713/large/matic-token-icon.png?1624446912',
      'optimism-ethereum' : 'https://assets.coingecko.com/coins/images/25244/large/Optimism.png?1660904599',
      'arbitrum-one' : 'https://assets.coingecko.com/asset_platforms/images/33/large/AO_logomark.png?1695026226',
      'avalanche' : 'https://assets.coingecko.com/coins/images/12559/large/Avalanche_Circle_RedWhite_Trans.png?1670992574',
      // 'solana' : 'https://assets.coingecko.com/coins/images/4128/large/solana.png?1640133422',
      'fantom' : 'https://assets.coingecko.com/coins/images/4001/large/Fantom_round.png?1669652346',
      'base' : 'https://assets.coingecko.com/asset_platforms/images/131/large/base.jpeg?1684806195',
      'cronos' : 'https://assets.coingecko.com/asset_platforms/images/46/large/cronos.jpeg?1636714736'
    };

    final ctaText = FlutterI18n.translate(context, 'add_wallet.supported_networks.cta');
    final infoTitleText = FlutterI18n.translate(context, 'add_wallet.supported_networks.title');
    final infoDescriptionText = FlutterI18n.translate(context, 'add_wallet.supported_networks.content');

    return InkWell(
      onTap: () {
        showModalBottomSheet(
            context: context,
            backgroundColor: Theme.of(context).colorScheme.background,
            showDragHandle: true,
            enableDrag: true,
            builder: (context) {
              return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(infoTitleText, style: Theme.of(context).textTheme.titleLarge),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: Text(infoDescriptionText, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 40),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            children: networksImagesMap.keys.map((network) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(networksImagesMap[network] ?? '', width: 32)
                              ),
                            )).toList(),
                          )
                        )
                      ]
                  )
              );
            }
        );
      },
      child: Container(
          margin: const EdgeInsets.only(top: 50),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(ctaText, style: Theme.of(context).textTheme.titleMedium),
                Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: const Icon(Icons.info, size: 22)
                )
              ]
          )
      )
    );
  }
}
