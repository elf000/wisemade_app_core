import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wisemade_app_core/app_state.dart';
import 'package:wisemade_app_core/widgets/shared/videos.dart';

import '../../models/video.dart';

class PortfolioVideosCarousel extends StatefulWidget {
  const PortfolioVideosCarousel({
    Key? key
  }) : super(key: key);

  @override
  State<PortfolioVideosCarousel> createState() => _PortfolioVideosCarouselState();
}

class _PortfolioVideosCarouselState extends State<PortfolioVideosCarousel> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, child) {
        List<Video> videos = state.videos;

        return Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: VideosCarousel(videos: videos)
        );
      }
    );
  }
}