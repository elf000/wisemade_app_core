import 'package:timeago/timeago.dart' as timeago;

import '../utils/timeago_ptbr.dart';

class Video {
  final String title;
  final String url;
  final String thumbnail;
  final String channelUrl;
  final String channelThumbnail;
  final DateTime publishedAt;
  final String channelName;


  const Video({
    required this.title,
    required this.url,
    required this.thumbnail,
    required this.channelUrl,
    required this.channelThumbnail,
    required this.publishedAt,
    required this.channelName,
  });

  String timeAgo() {
    timeago.setLocaleMessages('pt_BR', TimeagoPtbr());
    return timeago.format(publishedAt, locale: 'pt_BR');
  }

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      title: json['title'],
      url: json['url'],
      thumbnail: json['thumbnail'],
      channelUrl: json['channelUrl'],
      channelThumbnail: json['channelThumbnail'],
      publishedAt: DateTime.parse(json['publishedAt']),
      channelName: json['channelName'],
    );
  }
}