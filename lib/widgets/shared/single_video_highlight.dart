import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../models/video.dart';
import '../../pages/webview_screen.dart';

class SingleVideoHighlight extends StatelessWidget {
  const SingleVideoHighlight({
    Key? key,
    required this.video,
  }) : super(key: key);

  final Video video;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: InkWell(
        onTap: () {
          PersistentNavBarNavigator.pushNewScreen(
            context!,
            screen: WebviewScreen(url: video.url, title: video.title),
            withNavBar: false,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: SizedBox(
                height: 280,
                child: Stack(
                    fit: StackFit.expand,
                    children: [
                      FittedBox(
                        fit: BoxFit.fill,
                        child: Image.network(
                          video.thumbnail,
                          color: Colors.black54,
                          colorBlendMode: BlendMode.darken,
                        ),
                      ),
                      const Align(
                          alignment: Alignment.center,
                          child: Icon(Icons.play_circle, size: 64)
                      ),
                    ]
                )
              )
            ),
            Container(
                margin: const EdgeInsets.only(top: 10),
                child: Text(
                  video.channelName,
                  style: Theme.of(context).textTheme.bodySmall,
                )
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                video.title,
                style: Theme.of(context).textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              )
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              child: Text(video.timeAgo(), style: Theme.of(context).textTheme.bodySmall),
            )
          ]
        )
      )
    );
  }
}