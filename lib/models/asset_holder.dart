class AssetHolder {
  final int id;
  final String name;
  final String displayName;
  final String imageUrl;
  final List<String> imageUrls;
  final String? alias;
  final String type;
  final bool syncing;

  const AssetHolder({
    required this.id,
    required this.name,
    required this.displayName,
    required this.imageUrl,
    required this.imageUrls,
    required this.syncing,
    required this.type,
    this.alias
  });

  factory AssetHolder.fromJson(Map<String, dynamic> json) {
    return AssetHolder(
      id: json['id'],
      name: json['name'],
      displayName: json['displayName'],
      imageUrl: json['imageUrl'],
      imageUrls: json['imageUrls'].map<String>((e) => e.toString()).toList(),
      alias: json['alias'],
        syncing: json['syncing'],
        type: json['type']
    );
  }
}