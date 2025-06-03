import 'package:flutter/material.dart';

class CalcTransactionTotal {
  final BuildContext context;

  CalcTransactionTotal(this.context);

  double run({String? amount, String? price, String? taxes}) {
    if(amount != null && amount.isEmpty || price != null && price.isEmpty) {
      return 0.0;
    } else {
      return double.parse(amount!) * double.parse(price!) + double.parse(taxes!);
    }
  }
}