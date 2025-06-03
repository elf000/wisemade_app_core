import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:skeletons/skeletons.dart';
import 'package:wisemade_app_core/pages/market_news.dart';

import '../../models/news.dart';
import '../../pages/webview_screen.dart';
import 'carousel_skeleton.dart';

class InfluencersCarousel extends StatelessWidget {
  const InfluencersCarousel({
    Key? key,
    required this.influencers,
    this.selectedChannel,
    required this.onSelect,
  }) : super(key: key);

  final List influencers;
  final String? selectedChannel;
  final Function onSelect;

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 72,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: ListView(
          scrollDirection: Axis.horizontal,
          children: influencers.isNotEmpty ? [
            Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 5, 0),
                child: Thumbnail(
                  id: influencers.first['id'],
                  url: influencers!.first['thumbnail'],
                  selected: selectedChannel == influencers[0]['id'],
                  alwaysOn: selectedChannel == null,
                  onSelect: onSelect,
                )
            ),
            ...influencers.getRange(1, influencers.length - 1).map<Widget>((influencer) =>
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: Thumbnail(
                      id: influencer['id'],
                      url: influencer['thumbnail'],
                      selected: selectedChannel == influencer['id'],
                      alwaysOn: selectedChannel == null,
                      onSelect: onSelect,
                    )
                )
            ).toList(),
            Container(
                margin: const EdgeInsets.fromLTRB(5, 0, 20, 0),
                child: Thumbnail(
                  id: influencers[influencers.length - 1]['id'],
                  url: influencers[influencers.length - 1]['thumbnail'],
                  selected: selectedChannel == influencers[influencers.length - 1]['id'],
                  alwaysOn: selectedChannel == null,
                  onSelect: onSelect,
                )
            ),
          ] : [
            Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 5, 0),
                child: SkeletonAvatar(style: SkeletonAvatarStyle(height: 72, width: 72, borderRadius: BorderRadius.circular(50)))
            ),
            ...List.filled(6, null).map((i) => Container(
                margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: SkeletonAvatar(style: SkeletonAvatarStyle(height: 72, width: 72, borderRadius: BorderRadius.circular(50)))
            )).toList(),
            Container(
                margin: const EdgeInsets.fromLTRB(5, 0, 20, 0),
                child: SkeletonAvatar(style: SkeletonAvatarStyle(height: 72, width: 72, borderRadius: BorderRadius.circular(50)))
            ),
          ],
      ),
    );
  }
}

class Thumbnail extends StatelessWidget {
  final String id;
  final String url;
  final bool selected;
  final Function onSelect;
  final bool? alwaysOn;

  const Thumbnail({
    super.key,
    required this.id,
    required this.url,
    required this.selected,
    required this.onSelect,
    this.alwaysOn,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onSelect(id),
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      child: Container(
        height: 72,
        width: 72,
        decoration: BoxDecoration(
          border: selected && alwaysOn != true ? Border.all(
            width: 2,
            color: Theme.of(context).colorScheme.secondary
          ) : null,
          borderRadius: BorderRadius.circular(50)
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.network(
            url,
            width: 72,
            color: selected || alwaysOn == true ? Colors.white : Colors.black54,
            colorBlendMode: BlendMode.darken,
          )
        )
      )
    );
  }
}