import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../models/news.dart';
import '../../pages/webview_screen.dart';

class SingleNewsRow extends StatelessWidget {
  const SingleNewsRow({
    Key? key,
    required this.news,
  }) : super(key: key);

  final News news;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: InkWell(
        onTap: () {
          PersistentNavBarNavigator.pushNewScreen(
            context,
            screen: WebviewScreen(url: news.url, title: news.source),
            withNavBar: false,
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        news.title,
                        style: Theme.of(context).textTheme.titleSmall,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      )
                  ),
                  Text(news.timeAgo(), style: Theme.of(context).textTheme.bodySmall),
                ]
              )
            ),
            Expanded(
              flex: 4,
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(news.image),
                )
              )
            ),
          ]
        )
      )
    );
  }
}