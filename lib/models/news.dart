import 'package:timeago/timeago.dart' as timeago;

import '../utils/timeago_ptbr.dart';

class News {
  final int id;
  final String title;
  final String slug;
  final String source;
  final String image;
  final String url;
  final DateTime createdAt;
  final String description;


  const News({
    required this.id,
    required this.title,
    required this.slug,
    required this.source,
    required this.image,
    required this.url,
    required this.createdAt,
    required this.description,
  });

  String timeAgo() {
    timeago.setLocaleMessages('pt_BR', TimeagoPtbr());
    return timeago.format(createdAt, locale: 'pt_BR');
  }

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      source: json['source']['title'],
      image: json['image'] ?? '',
      url: json['source']['url'],
      createdAt: DateTime.parse(json['createdAt']),
      description: json['description'],
    );
  }
}