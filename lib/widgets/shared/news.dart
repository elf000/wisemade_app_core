import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:wisemade_app_core/pages/market_news.dart';

import '../../main.dart';
import '../../models/news.dart';
import '../../pages/webview_screen.dart';
import 'carousel_skeleton.dart';

class NewsCarousel extends StatelessWidget {
  const NewsCarousel({
    Key? key,
    required this.news,
    required this.loading,
    this.titleStyle,
    this.title,
    this.onSelect
  }) : super(key: key);

  final List<News> news;
  final TextStyle? titleStyle;
  final String? title;
  final bool loading;
  final Function? onSelect;

  @override
  Widget build(BuildContext context) {
    TextStyle style = titleStyle == null ? TextStyle(fontWeight: FontWeight.bold, fontSize: Theme.of(context).textTheme.titleMedium?.fontSize) : titleStyle!;
    final defaultTitleText = FlutterI18n.translate(context, 'home.news_carousel.title');
    final seeMoreText = FlutterI18n.translate(context, 'shared.see_more');

    return (news.isNotEmpty || loading) ? Container(
        margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title ?? defaultTitleText, style: style),
                  InkWell(
                    onTap: () {
                      mixpanel.track('Clicked on [View More]');
                      if(onSelect != null) {
                       onSelect!();
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const MarketNews())
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.only(right: 20),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: seeMoreText,
                              style: Theme.of(context).textTheme.titleSmall
                            ),
                            const WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Icon(Icons.arrow_forward_ios, size: 10),
                            ),
                          ],
                        ),
                      )
                    ),
                  )
                ]
              ),
              Container(
                height: 340,
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: loading
                    ? const CarouselSkeleton(length: 10, height: 320, width: 350)
                    : ListView(
                    scrollDirection: Axis.horizontal,
                    children: news.map<Widget>((n) =>
                      Container(
                          padding: const EdgeInsets.all(5),
                          child: Card(news: n)
                      )
                    ).toList()
                ),
              ),
            ]
        )
    ) : const SizedBox();
  }
}

class Card extends StatelessWidget {
  final News news;

  const Card({
    Key? key,
    required this.news,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          PersistentNavBarNavigator.pushNewScreen(
            context!,
            screen: WebviewScreen(url: news.url, title: news.source),
            withNavBar: false,
          );
        },
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        child: Container(
            width: 320,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              color: Theme.of(context).cardColor,
            ),
            child: Column(
                children: [
                  SizedBox(
                      height: 190,
                      width: 320,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Image.network(news.image, height: 200),
                      )
                  ),
                  Expanded(
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(news.source, style: Theme.of(context).textTheme.bodySmall),
                                Text(
                                  news.title,
                                  style: Theme.of(context).textTheme.titleMedium,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
                                Text(news.timeAgo(), style: Theme.of(context).textTheme.bodySmall),
                              ]
                          )
                      )
                  ),

                ]
            )
        )
    );
  }
}