import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import '../../models/video.dart';
import '../../pages/webview_screen.dart';

class VideosCarousel extends StatelessWidget {
  const VideosCarousel({
    Key? key,
    required this.videos,
    this.titleStyle,
  }) : super(key: key);

  final List<Video> videos;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    TextStyle style = titleStyle == null ? TextStyle(fontWeight: FontWeight.bold, fontSize: Theme.of(context).textTheme.titleMedium?.fontSize) : titleStyle!;
    final topInfluencersTitleText = FlutterI18n.translate(context, 'home.top_influencers.title');

    return videos.isNotEmpty ? Container(
        margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(topInfluencersTitleText, style: style),
              Container(
                height: 350,
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: videos.map<Widget>((n) =>
                      Container(
                          padding: const EdgeInsets.all(5),
                          child: Card(video: n)
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
  final Video video;

  const Card({
    Key? key,
    required this.video,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => WebviewScreen(url: video.url, title: video.title))
          )
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
                      height: 230,
                      width: 320,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          FittedBox(
                            fit: BoxFit.fill,
                            child: Image.network(
                              video.thumbnail,
                              height: 230,
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
                  ),
                  Expanded(
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(24),
                                        child: Image.network(video.channelThumbnail, height: 48)
                                      )
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            video.title,
                                            style: Theme.of(context).textTheme.titleMedium,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                          Text(
                                            video.channelName,
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.shadow),
                                            overflow: TextOverflow.ellipsis
                                          ),
                                        ]
                                      )
                                    )
                                  ]
                                ),
                                Text(video.timeAgo(), style: Theme.of(context).textTheme.bodySmall),
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