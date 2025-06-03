import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../utils/timeago_ptbr.dart';

class Coin {
  final int id;
  final String shortName;
  final String coingeckoSlug;
  final String imageUrl;
  final String symbol;

  final int? marketCapRank;
  final Map<String, dynamic>? links;
  final Map<String, dynamic>? networks;
  final List<double>? sparkline;
  final List<dynamic>? categories;
  final List<dynamic>? exchanges;
  final String? description;
  final Map<String, dynamic>? stats;
  final Map<String, dynamic>? social;


  const Coin({
    required this.id,
    required this.shortName,
    required this.coingeckoSlug,
    required this.imageUrl,
    required this.symbol,
    this.marketCapRank,
    this.links,
    this.networks,
    this.sparkline,
    this.description,
    this.stats,
    this.social,
    this.categories,
    this.exchanges
  });

  String formattedSymbol() => symbol.toUpperCase();

  double get currentPrice {
    return double.parse(stats?['currentPrice']?.toString() ?? '0');
  }

  double get currentPriceBrl {
    return double.parse(stats?['currentPriceBrl']?.toString() ?? '0');
  }

  double get currentPriceBtc {
    return double.parse(stats?['currentPriceBtc']?.toString() ?? '0');
  }

  double get currentPriceUsd {
    return double.parse(stats?['currentPriceUsd']?.toString() ?? '0');
  }

  double get currentPriceEur {
    return double.parse(stats?['currentPriceEur']?.toString() ?? '0');
  }

  double get marketCap {
    return double.parse(stats?['marketCap']?.toString() ?? '0');
  }

  double get marketCapChange24h {
    return double.parse(stats?['marketCapChange24h']?.toString() ?? '0');
  }

  double get marketCapChangePercentage24h {
    return double.parse(stats?['marketCapChangePercentage24h']?.toString() ?? '0');
  }

  double get priceChangePercentage24h {
    return double.parse(stats?['priceChangePercentage24h']?.toString() ?? '0');
  }

  double get totalVolume {
    return double.parse(stats?['totalVolume']?.toString() ?? '0');
  }

  double get circulatingSupply {
    return double.parse(stats?['circulatingSupply']?.toString() ?? '0');
  }

  double get totalSupply {
    return double.parse(stats?['totalSupply']?.toString() ?? '0');
  }

  double get maxSupply {
    return double.parse(stats?['maxSupply']?.toString() ?? '0');
  }

  double get marketDominance {
    return double.parse(stats?['marketDominance']?.toString() ?? '0');
  }

  double get socialDominance {
    return double.parse(stats?['socialDominance']?.toString() ?? '0');
  }

  double get ath {
    return double.parse(stats?['ath']?.toString() ?? '0');
  }

  double get athChangePercentage {
    return double.parse(stats?['athChangePercentage']?.toString() ?? '0');
  }

  String get athDate {
    if(stats?['athDate'] == null) return '';

    timeago.setLocaleMessages('pt_BR', TimeagoPtbr());
    final date = DateTime.parse(stats?['athDate']);
    final formattedDate = DateFormat('dd/MM/yyyy').format(date);
    timeago.setLocaleMessages('pt_BR', TimeagoPtbr());
    final ago = timeago.format(date, locale: 'pt_BR');
    return "$formattedDate ($ago)";
  }

  double get atl {
    return double.parse(stats?['atl']?.toString() ?? '0');
  }

  double get atlChangePercentage {
    return double.parse(stats?['atlChangePercentage']?.toString() ?? '0');
  }

  String get atlDate {
    if(stats?['atlDate'] == null) return '';

    timeago.setLocaleMessages('pt_BR', TimeagoPtbr());
    final date = DateTime.parse(stats?['atlDate']);
    final formattedDate = DateFormat('dd/MM/yyyy').format(date);
    timeago.setLocaleMessages('pt_BR', TimeagoPtbr());
    final ago = timeago.format(date, locale: 'pt_BR');
    return "$formattedDate ($ago)";
  }

  List<double> get sparklineData {
    return sparkline ?? [];
  }

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      id: json['id'],
      shortName: json['shortName'],
      coingeckoSlug: json['coingeckoSlug'] ?? json['slug'],
      imageUrl: json['imageUrl'],
      symbol: json['symbol'],
      marketCapRank: json['marketCapRank'],
      links: json['links'],
      sparkline: json['sparkline']?.map<double>((data) => double.parse(data.toString())).toList(),
      description: json['description'],
      stats: json['stats'],
      social: json['social'],
      categories: json['categories'],
      networks: json['networks'],
      exchanges: json['exchanges']
    );
  }
}