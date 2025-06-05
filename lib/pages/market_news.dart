import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '/infrastructure/wisemade_api.dart';
import '/widgets/shared/influencers_carousel.dart';
import '/widgets/shared/single_news_highlight.dart';
import '/widgets/shared/single_news_row.dart';
import '/widgets/shared/single_video_highlight.dart';

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
    final currentContext = context; // ← salva o contexto atual

    final appState = Provider.of<AppState>(currentContext, listen: false);
    final currentLocale = appState.currentLocale; // ← extrai antes do await
    appState.context = currentContext;

    await Future.wait([
      appState.getNews(),
      appState.getVideos(),
    ]);

    // ignore: use_build_context_synchronously
    final influencersData = await WisemadeApi(currentContext).fetchInfluencers(
      lang: currentLocale,
    );

    updateChannelVideos(widget.selectedInfluencer ?? influencersData.first['id']);

    if (!mounted) return;

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
            backgroundColor: Theme.of(context).colorScheme.surface,
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
                  ...news.getRange(1, news.length).map((n) => SingleNewsRow(news: n))
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
    return SingleChildScrollView(
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
                      children: loading
                          ? List.generate(5, (i) => Container(
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          child: Shimmer.fromColors(
                              baseColor: const Color(0xFF1a1931),
                              highlightColor: const Color(0xFF292845),
                              child: Container(
                                  height: 300,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade800,
                                      borderRadius: BorderRadius.circular(10)
                                  )
                              )
                          )
                      ))
                          : videos.map((v) => SingleVideoHighlight(video: v)).toList()
                  )
              ),
            ]
        )
    );
  }
}