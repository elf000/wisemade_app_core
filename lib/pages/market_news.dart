import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';
import 'package:wisemade_app_core/infrastructure/wisemade_api.dart';
import 'package:wisemade_app_core/widgets/shared/influencers_carousel.dart';
import 'package:wisemade_app_core/widgets/shared/single_news_highlight.dart';
import 'package:wisemade_app_core/widgets/shared/single_news_row.dart';
import 'package:wisemade_app_core/widgets/shared/single_video_highlight.dart';

import '../app_state.dart';
import '../main.dart';
import '../models/news.dart';
import '../widgets/shared/appbar.dart';
import 'authenticated_page.dart';

class MarketNews extends AuthenticatedPage {
  final int? initialTab;
  final String? selectedInfluencer;

  const MarketNews({
    super.key,
    this.initialTab,
    this.selectedInfluencer
  });

  @override
  AuthenticatedPageState<MarketNews> createState() => _MarketNewsState();
}

class _MarketNewsState extends AuthenticatedPageState<MarketNews> {
  List influencers = [];
  List videos = [];
  bool videosLoading = true;
  String? selectedChannel;

  Future getData() async {
    AppState appState = Provider.of<AppState>(context, listen: false);
    appState.context = context;

    await Future.wait([
      appState.getNews(),
      appState.getVideos(),
    ]);

    List influencersData = await WisemadeApi(context).fetchInfluencers(lang: appState.currentLocale);
    updateChannelVideos(widget.selectedInfluencer ?? influencersData.first['id']);

    setState(() {
      influencers = influencersData;
      selectedChannel = widget.selectedInfluencer ?? influencersData.first['id'];
    });
  }

  void updateChannelVideos(String channelId) async {
    setState(() {
      videosLoading = true;
    });

    List videosData = await WisemadeApi(context).fetchChannelVideos(channelId);

    setState(() {
      videos = videosData;
      videosLoading = false;
    });
  }

  @override
  void initState() {
    getData();

    super.initState();
  }

  Future<void> _pullRefresh() async {
    await getData();
  }

  @override
  Widget render(BuildContext context) {
    mixpanel.track('Viewed Screen - Market News');

    final titleText = FlutterI18n.translate(context, 'market_news.title');
    final newsTabText = FlutterI18n.translate(context, 'market_news.tabs.news');
    final influencersTabText = FlutterI18n.translate(context, 'market_news.tabs.influencers');

    return DefaultTabController(
      length: 2,
      initialIndex: widget.initialTab ?? 0,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: CustomAppBar(
            title: titleText,
            preferredSize: const Size.fromHeight(100),
            bottom: TabBar(
              indicatorColor: Theme.of(context).colorScheme.secondary,
              tabs: [
                Tab(text: newsTabText),
                Tab(text: influencersTabText)
              ]
            )
        ),
        body: SafeArea(
          child: Consumer<AppState>(
            builder: (context, state, child) {
              return RefreshIndicator(
                onRefresh: _pullRefresh,
                child: TabBarView(
                  children: [
                    NewsTab(news: state.news),
                    InfluencersTab(
                      influencers: influencers,
                      videos: videos,
                      loading: videosLoading,
                      selectedChannel: selectedChannel,
                      onSelect: (id) {
                        updateChannelVideos(id);
                        setState(() {
                          selectedChannel = id;
                        });
                      },
                    )
                  ]
                )
              );
            }
          )
        )
      )
    );
  }
}

class NewsTab extends StatelessWidget {
  final List<News> news;

  const NewsTab({
    super.key,
    required this.news
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            SingleNewsHighlight(news: news.first),
            ...news.getRange(1, news.length).map((n) => SingleNewsRow(news: n)).toList()
          ]
        ).toList()
      )
    );
  }
}


class InfluencersTab extends StatelessWidget {
  final List influencers;
  final List videos;
  final bool loading;
  final String? selectedChannel;
  final Function onSelect;

  const InfluencersTab({
    super.key,
    required this.influencers,
    required this.videos,
    required this.loading,
    required this.selectedChannel,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: InfluencersCarousel(
                influencers: influencers,
                selectedChannel: selectedChannel,
                onSelect: onSelect,
              )
            ),
            Container(
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  children: loading == true
                    ? List.filled(5, null).map((i) => Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        child: const SkeletonLine(style: SkeletonLineStyle(height: 300)))
                      ).toList()
                    : videos.map((v) => SingleVideoHighlight(video: v)).toList()
                )
            ),
          ]
        )
      );
  }
}
