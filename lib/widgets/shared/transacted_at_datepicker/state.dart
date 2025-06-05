import 'package:flutter/material.dart';

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