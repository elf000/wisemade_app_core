import 'package:flutter/material.dart';

import '../../../models/coin.dart';
import '../../../models/exchange.dart';


class CoinsAutocompleteState extends ChangeNotifier {
  final BuildContext context;

  Coin? selectedCoin;

  CoinsAutocompleteState(this.context);

  void clearSelectedCoin() {
    selectedCoin = null;
    notifyListeners();
  }

  Future<void> selectCoin(Coin? coin) async {

    selectedCoin = coin;

    notifyListeners();
  }
}