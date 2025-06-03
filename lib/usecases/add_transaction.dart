import 'package:flutter/material.dart';
import 'package:wisemade_app_core/infrastructure/wisemade_api.dart';

class AddTransactionUseCase {
  final BuildContext context;

  AddTransactionUseCase(this.context);

  Future run(Map<String, dynamic> payload) {
    return WisemadeApi(context).addTransaction(payload);
  }
}