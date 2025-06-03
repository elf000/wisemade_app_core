import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wisemade_app_core/app_state.dart';

import '../../models/news.dart';
import '../shared/news.dart';

class CoinNewsCarousel extends StatefulWidget {
  final String? title;

  const CoinNewsCarousel({
    Key? key,
    this.title
  }) : super(key: key);

  @override
  State<CoinNewsCarousel> createState() => _CoinNewsCarouselState();
}

class _CoinNewsCarouselState extends State<CoinNewsCarousel> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, child) {
        List<News> news = state.coinNews;
        bool newsLoading = state.coinNewsLoading;

        return NewsCarousel(
          news: news,
          title: widget.title,
          loading: newsLoading,
          titleStyle: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
        );
      }
    );
  }
}