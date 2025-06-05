import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wisemade_app_core/widgets/shared/transacted_at_datepicker/state.dart';

import '../../../app_state.dart';
import '../list_item.dart';


class TransactedAtDatepicker extends StatefulWidget {
  final Function onSelect;

  const TransactedAtDatepicker({
    Key? key,
    required this.onSelect
  }) : super(key: key);

  @override
  State<TransactedAtDatepicker> createState() => _TransactionDatepickerState();
}


class _TransactionDatepickerState extends State<TransactedAtDatepicker> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<TransactedAtDatepickerState, AppState>(
        builder: (context, dateState, appState, child) {
          final transactedAtText = FlutterI18n.translate(context, 'add_transaction.transacted_at', translationParams: {
            'date': DateFormat('dd/MM/yyyy').format(dateState.selectedDate)
          });

          return InkWell(
              onTap: () async {
                DateTime? transactedAt = await showDatePicker(
                  context: context,
                  initialDate: dateState.selectedDate,
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now(),
                );

                if(transactedAt != null) {
                  setState(() {
                    dateState.selectDate(transactedAt);
                  });
                }
              },
              child: (() {
                return ListItem(
                    height: 60,
                    padding: 20,
                    margin: 0,
                    children: [
                      Text(
                        transactedAtText,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16)
                    ]
                );
              }())
          );
        }
    );
  }
}