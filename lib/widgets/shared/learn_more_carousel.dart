import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../pages/webview_screen.dart';

class LearnMoreCarousel extends StatefulWidget {
  const LearnMoreCarousel({
    Key? key,
  }) : super(key: key);

  @override
  State<LearnMoreCarousel> createState() => _LearnMoreCarouselState();
}

class _LearnMoreCarouselState extends State<LearnMoreCarousel> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cryptoGuidePart1Text = FlutterI18n.translate(context, 'explore.learn_more.crypto_guide.part_1');
    final cryptoGuidePart2Text = FlutterI18n.translate(context, 'explore.learn_more.crypto_guide.part_2');
    final cryptoGuideWebviewTitleText = FlutterI18n.translate(context, 'explore.learn_more.crypto_guide.webview_title');
    final cryptoGuideCTAText = FlutterI18n.translate(context, 'explore.learn_more.crypto_guide.cta');
    final nftGuidePart1Text = FlutterI18n.translate(context, 'explore.learn_more.nft_guide.part_1');
    final nftGuidePart2Text = FlutterI18n.translate(context, 'explore.learn_more.nft_guide.part_2');
    final nftGuideWebviewTitleText = FlutterI18n.translate(context, 'explore.learn_more.nft_guide.webview_title');
    final nftGuideCTAText = FlutterI18n.translate(context, 'explore.learn_more.nft_guide.cta');

    return SizedBox(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Card(
            margin: const EdgeInsets.fromLTRB(20, 0, 5, 0),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('6 min', style: Theme.of(context).textTheme.bodySmall, softWrap: true, maxLines: 3),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: RichText(
                          text: TextSpan(
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(text: cryptoGuidePart1Text),
                                TextSpan(text: cryptoGuidePart2Text, style: const TextStyle(color: Colors.deepOrange))
                              ]
                          ),
                        )
                      ),
                      OutlinedButton(
                        onPressed: () {
                          PersistentNavBarNavigator.pushNewScreen(
                            context,
                            screen: WebviewScreen(
                                title: cryptoGuideWebviewTitleText,
                                url: 'https://blog.wisemade.io/guia-para-iniciantes-sobre-criptomoedas/'
                            ),
                            withNavBar: false,
                          );
                        },
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.deepPurple)),
                        child: Text(cryptoGuideCTAText),
                      )
                    ]
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: Image.asset('images/owl-with-bitcoin-2.png', width: 130)
                  )
                ]
              )
            )
          ),
          Card(
            margin: const EdgeInsets.fromLTRB(5, 0, 20, 0),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('6 min', style: Theme.of(context).textTheme.bodySmall, softWrap: true, maxLines: 3),
                        Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: RichText(
                              text: TextSpan(
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                                  children: [
                                    TextSpan(text: nftGuidePart1Text),
                                    TextSpan(text: nftGuidePart2Text, style: const TextStyle(color: Colors.deepOrange))
                                  ]
                              ),
                            )
                        ),
                        OutlinedButton(
                          onPressed: () {
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: WebviewScreen(
                                  title: nftGuideWebviewTitleText,
                                  url: 'https://blog.wisemade.io/guia-para-iniciantes-sobre-nfts-o-que-sao-non-fungible-tokens/'
                              ),
                              withNavBar: false,
                            );
                          },
                          style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.deepPurple)),
                          child: Text(nftGuideCTAText),
                        )
                      ]
                  ),
                  Container(
                      padding: const EdgeInsets.only(left: 20),
                      child: Image.asset('images/owl-with-nft.png', width: 120)
                  )
                ]
              )
            )
          )
        ]
      ),
    );
  }
}

class Card extends StatelessWidget {
  final Widget child;
  final EdgeInsets margin;

  const Card({
    super.key,
    required this.child,
    required this.margin
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: margin,
        decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(5)),
        child: child
    );
  }
}