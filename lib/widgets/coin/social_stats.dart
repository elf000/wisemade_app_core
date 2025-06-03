import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import '../../models/coin.dart';
import '../shared/list_skeleton.dart';

class SocialStats extends StatefulWidget {
  final Coin? coin;

  const SocialStats({
    Key? key,
    required this.coin,
  }) : super(key: key);

  @override
  State<SocialStats> createState() => _SocialStatsState();
}

class _SocialStatsState extends State<SocialStats> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final socialEngagementText = FlutterI18n.translate(context, 'coin.social_stats.social_engagement');
    final mentionsText = FlutterI18n.translate(context, 'coin.social_stats.mentions');
    final sharesText = FlutterI18n.translate(context, 'coin.social_stats.shares');
    final tweetsText = FlutterI18n.translate(context, 'coin.social_stats.tweets');
    final redditText = FlutterI18n.translate(context, 'coin.social_stats.reddit');
    final youtubeText = FlutterI18n.translate(context, 'coin.social_stats.youtube');

    return widget.coin == null
      ? const ListSkeleton(size: 4, height: 90)
      : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(widget.coin!.social?['socialVolume'] != null && widget.coin!.social?['socialVolume'] != 0) Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Text(socialEngagementText, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          ),
          Card(
              label: mentionsText,
              value: widget.coin!.social?['socialVolume'],
              valueStyle: Theme.of(context).textTheme.titleMedium
          ),
          Card(
              label: sharesText,
              value: widget.coin!.social?['urlSharesAmount24h'],
              valueStyle: Theme.of(context).textTheme.titleMedium
          ),
          Card(
              label: tweetsText,
              value: widget.coin!.social?['tweetsAmount24h'],
              valueStyle: Theme.of(context).textTheme.titleMedium
          ),
          Card(
              label: redditText,
              value: widget.coin!.social?['redditAmount24h'],
              valueStyle: Theme.of(context).textTheme.titleMedium
          ),
          Card(
              label: youtubeText,
              value: widget.coin!.social?['youtubeAmount24h'],
              valueStyle: Theme.of(context).textTheme.titleMedium
          ),
        ]
      );
  }
}

class Card extends StatelessWidget {
  final String label;
  final int? value;
  final TextStyle? valueStyle;

  const Card({
    Key? key,
    required this.label,
    required this.value,
    this.valueStyle
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return value != null && value != 0 ? Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      margin: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(color: Theme.of(context).cardColor),
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.shadow),
          ),
          Text(value!.toString(), style: Theme.of(context).textTheme.headlineSmall?.merge(valueStyle)),
        ]
      )
    ) : const SizedBox();
  }
}