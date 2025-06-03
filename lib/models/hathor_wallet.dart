class HathorWallet {
  final int id;
  final String name;
  final String displayName;
  final String imageUrl;
  final String? alias;
  final String type;
  final bool syncing;

  const HathorWallet({
    required this.id,
    required this.name,
    required this.displayName,
    required this.imageUrl,
    required this.syncing,
    required this.type,
    this.alias
  });

  factory HathorWallet.fromJson(Map<String, dynamic> json) {
    return HathorWallet(
      id: json['id'],
      name: json['name'],
      displayName: json['displayName'],
      imageUrl: json['imageUrl'],
      alias: json['alias'],
        syncing: json['syncing'],
        type: json['type']
    );
  }
}