class PortfolioSnapshot {
  final double balance;
  final double profit;
  final double taxes;
  final double totalInvested;
  final double profitPercentage;


  const PortfolioSnapshot({
    required this.balance,
    required this.profit,
    required this.taxes,
    required this.totalInvested,
    required this.profitPercentage,
  });

  factory PortfolioSnapshot.fromJson(Map<String, dynamic> json) {
    return PortfolioSnapshot(
      balance: json['balance'].toDouble(),
      profit: json['profit'].toDouble(),
      taxes: json['taxes'].toDouble(),
      totalInvested: json['totalInvested'].toDouble(),
      profitPercentage: json['profitPercentage'].toDouble(),
    );
  }
}