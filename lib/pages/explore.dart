import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:wisemade_app_core/infrastructure/wisemade_api.dart';
import 'package:wisemade_app_core/widgets/shared/influencers_carousel.dart';
import 'package:wisemade_app_core/widgets/shared/single_news_highlight.dart';
import 'package:wisemade_app_core/widgets/shared/single_video_highlight.dart';

import '../app_state.dart';
import '../main.dart';
import '../widgets/shared/learn_more_carousel.dart';
import '../widgets/shared/appbar.dart';
import 'authenticated_page.dart';
import 'market_news.dart';

class ExplorePage extends AuthenticatedPage {
  const ExplorePage({super.key});

  @override
  AuthenticatedPageState<ExplorePage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends AuthenticatedPageState<ExplorePage> {
  List influencers = [];

  Future getData() async {
    AppState appState = Provider.of<AppState>(context, listen: false);
    appState.context = context;

    await Future.wait([
      appState.getNews(),
      appState.getTrendingCoins(),
    ]);

    if(!mounted) return;
    final influencersData = await WisemadeApi(context).fetchInfluencers(lang: appState.currentLocale);
    setState(() {
      influencers = influencersData;
    });
  }

  @override
  void initState() {
    getData();

    super.initState();
  }

  @override
  Widget render(BuildContext context) {
    mixpanel.track('Viewed Screen - Explore');

    final titleText = FlutterI18n.translate(context, 'navbar.explore');
    final topInfluencersText = FlutterI18n.translate(context, 'explore.top_influencers');
    final seeMoreText = FlutterI18n.translate(context, 'shared.see_more');
    final latestNewsText = FlutterI18n.translate(context, 'home.news_carousel.title');
    final relevantVideosText = FlutterI18n.translate(context, 'explore.relevant_videos');

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: CustomAppBar(preferredSize: const Size.fromHeight(70), withSearch: true, withAvatar: true, title: titleText),
      body: SafeArea(
        child: Consumer<AppState>(
          builder: (context, state, child) {
            return SingleChildScrollView(
                clipBehavior: Clip.none,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(topInfluencersText, style: Theme.of(context).textTheme.titleMedium),
                            InkWell(
                              onTap: () {
                                mixpanel.track('Clicked on Influencers');
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const MarketNews(initialTab: 1))
                                );
                              },
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: seeMoreText,
                                        style: Theme.of(context).textTheme.titleSmall
                                    ),
                                    const WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: Icon(Icons.arrow_forward_ios, size: 10),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ]
                        )
                      ),
                      InfluencersCarousel(
                        influencers: influencers,
                        onSelect: (String id) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MarketNews(initialTab: 1, selectedInfluencer: id))
                          );
                        }
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: const Divider(),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(latestNewsText, style: Theme.of(context).textTheme.titleMedium),
                                  InkWell(
                                    onTap: () {
                                      mixpanel.track('Clicked on News');
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => const MarketNews())
                                      );
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                              text: seeMoreText,
                                              style: Theme.of(context).textTheme.titleSmall
                                          ),
                                          const WidgetSpan(
                                            alignment: PlaceholderAlignment.middle,
                                            child: Icon(Icons.arrow_forward_ios, size: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ]
                            ),
                            if(state.news.isNotEmpty) SingleNewsHighlight(news: state.news.first),
                          ]
                        )
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: const Divider(),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(relevantVideosText, style: Theme.of(context).textTheme.titleMedium),
                                InkWell(
                                  onTap: () {
                                    mixpanel.track('Clicked on Videos');
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => const MarketNews(initialTab: 1,))
                                    );
                                  },
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                            text: seeMoreText,
                                            style: Theme.of(context).textTheme.titleSmall
                                        ),
                                        const WidgetSpan(
                                          alignment: PlaceholderAlignment.middle,
                                          child: Icon(Icons.arrow_forward_ios, size: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ]
                            ),
                            if(state.videos.isNotEmpty) SingleVideoHighlight(video: state.videos.first),
                          ]
                        )
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 20, bottom: 40),
                        child: const LearnMoreCarousel(),
                      ),
                    ]
                  )
                )
              );
          }
        )
      )
    );
  }
}