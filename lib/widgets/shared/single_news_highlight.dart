import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../models/news.dart';
import '../../pages/webview_screen.dart';

class SingleNewsHighlight extends StatelessWidget {
  const SingleNewsHighlight({
    Key? key,
    required this.news,
  }) : super(key: key);

  final News news;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
      child: InkWell(
        onTap: () {
          PersistentNavBarNavigator.pushNewScreen(
            context!,
            screen: WebviewScreen(url: news.url, title: news.source),
            withNavBar: false,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(news.image),
            ),
            Container(
                margin: const EdgeInsets.only(top: 20),
                child: Text(
                  news.source,
                  style: Theme.of(context).textTheme.bodySmall,
                )
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                news.title,
                style: Theme.of(context).textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              )
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              child: Text(news.timeAgo(), style: Theme.of(context).textTheme.bodySmall),
            )
          ]
        )
      )
    );
  }
}