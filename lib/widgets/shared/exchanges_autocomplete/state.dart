import 'package:flutter/material.dart';

import '../../../models/exchange.dart';


class ExchangesAutocompleteState extends ChangeNotifier {
  final BuildContext context;

  Exchange? selectedExchange;

  ExchangesAutocompleteState(this.context);

  Future<void> selectExchange(Exchange? exchange) async {

    selectedExchange = exchange;

    notifyListeners();
  }
}