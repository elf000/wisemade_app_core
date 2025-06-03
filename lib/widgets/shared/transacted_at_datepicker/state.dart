import 'package:flutter/material.dart';

import '../../../models/coin.dart';
import '../../../models/exchange.dart';


class TransactedAtDatepickerState extends ChangeNotifier {
  final BuildContext context;

  DateTime selectedDate = DateTime.now();

  TransactedAtDatepickerState(this.context);

  void clearSelectedDate() {
    selectedDate = DateTime.now();
    notifyListeners();
  }

  Future<void> selectDate(DateTime datetime) async {

    selectedDate = datetime;

    notifyListeners();
  }
}