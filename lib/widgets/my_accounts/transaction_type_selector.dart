import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class TransactionTypeSelector extends StatefulWidget {
  final TextEditingController controller;

  const TransactionTypeSelector({
    Key? key,
    required this.controller
  }) : super(key: key);

  @override
  State<TransactionTypeSelector> createState() => _TransactionTypeSelectorState();
}

class _TransactionTypeSelectorState extends State<TransactionTypeSelector> {
  String _selectedOption = 'deposit';

  @override
  void initState() {
    widget.controller.text = _selectedOption;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final depositText = FlutterI18n.translate(context, 'transactions.transaction_type.deposit');
    final withdrawalText = FlutterI18n.translate(context, 'transactions.transaction_type.withdrawal');
    final options = { 'deposit' : depositText, 'withdrawal' : withdrawalText };

    return Container(
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(5)),
      child: ToggleButtons(
        direction: Axis.horizontal,
        onPressed: (int index) {
          setState(() {
            _selectedOption = index == 0 ? 'deposit' : 'withdrawal';
            widget.controller.text = _selectedOption;
          });
        },
        borderWidth: 0,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        borderColor: Theme.of(context).cardColor,
        selectedBorderColor: Theme.of(context).cardColor,
        selectedColor: Colors.white,
        fillColor: Theme.of(context).colorScheme.secondary,
        constraints: BoxConstraints(
          minHeight: 55.0,
          minWidth: (MediaQuery.of(context).size.width / 2) - 22,
        ),
        isSelected: [_selectedOption == 'deposit', _selectedOption == 'withdrawal'],
        children: options.values.map((e) => Text(e)).toList(),
      )
    );
  }
}