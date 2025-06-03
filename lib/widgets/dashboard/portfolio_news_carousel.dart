import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:wisemade_app_core/app_state.dart';

import '../../models/news.dart';
import '../../pages/market_news.dart';
import '../shared/news.dart';

class PortfolioNewsCarousel extends StatefulWidget {
  const PortfolioNewsCarousel({
    Key? key
  }) : super(key: key);

  @override
  State<PortfolioNewsCarousel> createState() => _PortfolioNewsCarouselState();
}

class _PortfolioNewsCarouselState extends State<PortfolioNewsCarousel> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, child) {
        List<News> news = state.news;
        bool loading = state.newsLoading;
        final titleText = FlutterI18n.translate(context, 'home.news_carousel.title');

        return Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: NewsCarousel(
            news: news,
            loading: loading,
            title: titleText,
            onSelect: () {
              state.tabController.jumpToTab(4);
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          )
        );
      }
    );
  }
}