import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class InfluencersCarousel extends StatelessWidget {
  const InfluencersCarousel({
    super.key,
    required this.influencers,
    this.selectedChannel,
    required this.onSelect,
  });

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
        children: influencers.isNotEmpty
            ? [
          // Primeiro
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 5, 0),
            child: Thumbnail(
              id: influencers.first['id'],
              url: influencers.first['thumbnail'],
              selected: selectedChannel == influencers[0]['id'],
              alwaysOn: selectedChannel == null,
              onSelect: onSelect,
            ),
          ),
          // Meio
          for (var influencer in influencers.sublist(1, influencers.length - 1))
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: Thumbnail(
                id: influencer['id'],
                url: influencer['thumbnail'],
                selected: selectedChannel == influencer['id'],
                alwaysOn: selectedChannel == null,
                onSelect: onSelect,
              ),
            ),
          // Último
          Container(
            margin: const EdgeInsets.fromLTRB(5, 0, 20, 0),
            child: Thumbnail(
              id: influencers.last['id'],
              url: influencers.last['thumbnail'],
              selected: selectedChannel == influencers.last['id'],
              alwaysOn: selectedChannel == null,
              onSelect: onSelect,
            ),
          ),
        ]
            : [
          const SizedBox(width: 20),
          for (int i = 0; i < 8; i++)
            Container(
              margin: EdgeInsets.only(
                left: i == 0 ? 0 : 5,
                right: i == 7 ? 20 : 5,
              ),
              child: const ShimmerCircle(),
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
          border: selected && alwaysOn != true
              ? Border.all(
            width: 2,
            color: Theme.of(context).colorScheme.secondary,
          )
              : null,
          borderRadius: BorderRadius.circular(50),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.network(
            url,
            width: 72,
            color: selected || alwaysOn == true ? Colors.white : Colors.black54,
            colorBlendMode: BlendMode.darken,
          ),
        ),
      ),
    );
  }
}

class ShimmerCircle extends StatelessWidget {
  const ShimmerCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF2A2A2A),
      highlightColor: const Color(0xFF3A3A3A),
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }
}