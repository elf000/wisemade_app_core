import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:wisemade_app_core/models/asset_holder.dart';
import 'package:wisemade_app_core/utils/format.dart';

import '../utils/timeago_ptbr.dart';
import 'my_coin.dart';

class Transaction {
  final int id;
  final double amount;
  final double price;
  final double taxes;
  final String transactionType;
  final DateTime transactedAt;

  final MyCoin coin;
  final AssetHolder exchangePortfolio;

  const Transaction({
    required this.id,
    required this.amount,
    required this.price,
    required this.taxes,
    required this.coin,
    required this.transactedAt,
    required this.transactionType,
    required this.exchangePortfolio,
  });

  String formattedTransactionType() {
   return {
      'buy' : 'Compra',
      'sell' : 'Venda',
      'deposit' : 'Depósito',
      'withdrawal' : 'Saque',
      'fee' : 'Taxas',
      'staking' : 'Staking',
      'future_profit' : 'Lucro',
      'future_loss' : 'Perda'
    }[transactionType] ?? '';
  }

  double totalSpent() {
    return amount * price;
  }

  String formattedAmount() {
    final f = NumberFormat("#,##0.00#########", "pt_BR");
    return "${f.format(amount)} ${coin.formattedSymbol()}";
  }

  bool isPositive() => ['buy', 'deposit', 'staking', 'future_profit'].contains(transactionType);

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      amount: double.parse(json['amount']),
      price: double.parse(json['price']),
      taxes: double.parse(json['taxes']),
      transactionType: json['transactionType'],
      transactedAt: DateTime.parse(json['transactedAt']),
      coin: MyCoin.fromPartialJson(json['coin']),
      exchangePortfolio: AssetHolder.fromJson(json['exchangePortfolio']),
    );
  }
}