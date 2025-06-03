import 'package:intl/intl.dart';

import 'coin.dart';

class MyCoin extends Coin {
  final double currentPrice;

  final double? totalAmount;
  final double? totalDeposited;
  final double? totalInvested;
  final double? totalTaxes;
  final double? averageBuyPrice;
  final double? balance;
  final double? profitPercentage;
  final double? profitValue;

  const MyCoin({
    required int id,
    required String shortName,
    required String coingeckoSlug,
    required String imageUrl,
    required String symbol,
    required this.currentPrice,
    this.totalAmount,
    this.totalDeposited,
    this.totalInvested,
    this.totalTaxes,
    this.averageBuyPrice,
    this.balance,
    this.profitPercentage,
    this.profitValue,
    exchanges,
    marketCapRank,
    stats
  }) : super(
    id: id,
    shortName: shortName,
    coingeckoSlug: coingeckoSlug,
    imageUrl: imageUrl,
    symbol: symbol,
    exchanges: exchanges,
    marketCapRank: marketCapRank,
    stats: stats
  );

  String formattedTotalAmount() {
    final f = NumberFormat("#,##0.00######", "pt_BR");
    return "${f.format(totalAmount)} ${formattedSymbol()}";
  }

  factory MyCoin.fromPartialJson(Map<String, dynamic> json) {
    return MyCoin(
      id: json['id'],
      shortName: json['shortName'],
      coingeckoSlug: json['coingeckoSlug'] ?? json['slug'],
      imageUrl: json['imageUrl'],
      symbol: json['symbol'],
      currentPrice: json['currentPrice']?.toDouble() ?? 0,
      marketCapRank: json['marketCapRank'],
      exchanges: json['exchanges'],
      stats: json['stats']
    );
  }

  factory MyCoin.fromFullJson(Map<String, dynamic> json) {
    return MyCoin(
      id: json['id'],
      shortName: json['shortName'],
      coingeckoSlug: json['coingeckoSlug'] ?? json['slug'],
      imageUrl: json['imageUrl'],
      symbol: json['symbol'],
      exchanges: json['exchanges'],
      totalAmount: double.parse(json['totalAmount']),
      totalDeposited: double.parse(json['totalDeposited']),
      totalInvested: double.parse(json['totalInvested']),
      totalTaxes: double.parse(json['totalTaxes']),
      averageBuyPrice: double.parse(json['averageBuyPrice']),
      currentPrice: json['currentPrice'].toDouble(),
      balance: double.parse(json['balance']),
      profitPercentage: double.parse(json['profitPercentage']),
      profitValue: double.parse(json['profitValue']),
      marketCapRank: json['marketCapRank'],
      stats: json['stats']
    );
  }
}