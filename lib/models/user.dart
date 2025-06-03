class User {
  final int id;
  final String name;
  final String? email;
  final Map<String, dynamic>? avatar;
  final Map<String, dynamic>? metadata;
  final bool isSubscribed;
  final String? metamaskPublicAddress;

  final String fiatSymbol;
  final String fiatPrefix;


  const User({
    required this.id,
    required this.name,
    required this.avatar,
    required this.isSubscribed,
    required this.fiatSymbol,
    required this.fiatPrefix,
    this.metamaskPublicAddress,
    this.metadata,
    this.email
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'],
      isSubscribed: json['subscribed?'],
      metamaskPublicAddress: json['metamaskPublicAddress'],
      metadata: json['metadata'],
      fiatSymbol: json['fiatSymbol'],
      fiatPrefix: json['fiatPrefix'],
    );
  }
}