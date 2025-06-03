class Exchange {
  final int id;
  final String name;
  final String? url;
  final String? imageUrl;

  const Exchange({
    required this.id,
    required this.name,
    this.imageUrl,
    this.url,
  });

  factory Exchange.fromJson(Map<String, dynamic> json) {
    return Exchange(
      id: json['id'],
      name: json['name'],
      url: json['url'],
      imageUrl: json['imageUrl']
    );
  }
}