
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wisemade_app_core/widgets/my_accounts/transaction_type_selector.dart';

import '../../app_state.dart';
import '../../models/coin.dart';
import '../../models/exchange.dart';
import '../../usecases/calc_transaction_total.dart';
import '../../utils/currency_input_formatter.dart';
import '../shared/coins_autocomplete/autocomplete.dart';
import '../shared/coins_autocomplete/state.dart';
import '../shared/exchanges_autocomplete/autocomplete.dart';
import '../shared/exchanges_autocomplete/state.dart';
import '../shared/transacted_at_datepicker/datepicker.dart';
import '../shared/transacted_at_datepicker/state.dart';

class AddTransaction extends StatefulWidget {

  const AddTransaction({
    Key? key
  }) : super(key: key);

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final amountController = TextEditingController();
  final priceController = TextEditingController();
  final taxesController = TextEditingController();
  final transactionTypeController = TextEditingController();

  final CurrencyInputFormatter _priceFormatter = CurrencyInputFormatter();
  final CurrencyInputFormatter _taxesFormatter = CurrencyInputFormatter();

  late String transactionTotal;
  late String pricePrefix;

  @override
  void initState() {
    super.initState();
    AppState state = Provider.of<AppState>(context, listen: false);
    pricePrefix = state.currentUser?.fiatPrefix ?? "\$";

    transactionTotal = "$pricePrefix 0,00";
  }


  @override
  void dispose() {
    amountController.dispose();
    priceController.dispose();
    taxesController.dispose();
    transactionTypeController.dispose();

    super.dispose();
  }

  void updateTransactionTotal({ num? price }) {
    NumberFormat f = NumberFormat.currency(
        locale: 'pt_BR',
        symbol: "$pricePrefix ",
        decimalDigits: 2
    );

    setState(() {
      transactionTotal = f.format(CalcTransactionTotal(context).run(
          amount: amountController.text.replaceAll(',', '.'),
          price: price != null ? price.toString() : _priceFormatter.getUnformattedValue().toString(),
          taxes: _taxesFormatter.getUnformattedValue().toString()
      ));
    });
  }

  void clearForm(ExchangesAutocompleteState exchangesAutocompleteState, CoinsAutocompleteState coinsAutocompleteState, TransactedAtDatepickerState dateState) {
    amountController.clear();
    priceController.clear();
    taxesController.clear();
    transactionTypeController.clear();

    setState(() {
      transactionTotal = "$pricePrefix 0,00";
      exchangesAutocompleteState.selectExchange(null);
      coinsAutocompleteState.selectCoin(null);
      dateState.selectDate(DateTime.now());
    });
  }

  bool isFormReady(Exchange? exchange, Coin? coin, String amount, String price) {
    return exchange != null
        && coin != null
        && amount != ''
        && double.parse(amount) > 0
        && price != ''
        && double.parse(price) > 0;
  }

  @override
  Widget build(BuildContext context) {
    final amountText = FlutterI18n.translate(context, 'add_transaction.amount');
    final priceText = FlutterI18n.translate(context, 'add_transaction.price');
    final feeText = FlutterI18n.translate(context, 'add_transaction.fee');
    final totalText = FlutterI18n.translate(context, 'add_transaction.total');
    final buttonText = FlutterI18n.translate(context, 'add_transaction.button');

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (BuildContext context) => ExchangesAutocompleteState(context)),
          ChangeNotifierProvider(create: (BuildContext context) => CoinsAutocompleteState(context)),
          ChangeNotifierProvider(create: (BuildContext context) => TransactedAtDatepickerState(context))
        ],
        child: Consumer4<AppState, ExchangesAutocompleteState, CoinsAutocompleteState, TransactedAtDatepickerState>(
            builder: (context, appState, exchangesAutocompleteState, coinsAutocompleteState, dateState, widget) {

              return SingleChildScrollView(
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                      child: Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                              children: [
                                Container(
                                    padding: const EdgeInsets.symmetric(vertical: 15),
                                    child: TransactionTypeSelector(controller: transactionTypeController)
                                ),
                                Container(
                                    padding: const EdgeInsets.symmetric(vertical: 15),
                                    child: ExchangesAutocomplete(onSelect: (Exchange exchange) {
                                      exchangesAutocompleteState.selectExchange(exchange);
                                      appState.clearCoinPrice();
                                      Navigator.pop(context);
                                    })
                                ),
                                Container(
                                    padding: const EdgeInsets.symmetric(vertical: 15),
                                    child: CoinsAutocomplete(
                                      exchange: exchangesAutocompleteState.selectedExchange,
                                      onSelect: (Coin coin) async {
                                        coinsAutocompleteState.selectCoin(coin);
                                        Navigator.pop(context);
                                        await appState.getCoinPrice(coin);
                                        List<String> priceParts = appState.coinPrice.toString().split('.');
                                        String price = "${priceParts[0]}.${(priceParts.length == 2 ? priceParts[1] : '0').padRight(2, '0')}";
                                        priceController.text = _priceFormatter.format(price);
                                        updateTransactionTotal(price: appState.coinPrice);
                                      },
                                    )
                                ),
                                Container(
                                    padding: const EdgeInsets.symmetric(vertical: 15),
                                    child: TextFormField(
                                      controller: amountController,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                      inputFormatters: [
                                        TextInputFormatter.withFunction(
                                              (oldValue, newValue) => newValue.copyWith(
                                            text: newValue.text.replaceAll('.', ','),
                                          ),
                                        )
                                      ],
                                      decoration: InputDecoration(
                                        labelText: amountText,
                                      ),
                                      onChanged: (String value) {
                                        updateTransactionTotal();
                                      },
                                      validator: (value) => null,
                                    )
                                ),
                                Container(
                                    padding: const EdgeInsets.symmetric(vertical: 15),
                                    child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                                padding: const EdgeInsets.only(right: 5),
                                                child: TextFormField(
                                                  key: Key(appState.coinPrice.toString()),
                                                  controller: priceController,
                                                  textInputAction: TextInputAction.next,
                                                  inputFormatters: <TextInputFormatter>[_priceFormatter],
                                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                                  decoration: InputDecoration(
                                                    labelText: priceText,
                                                  ),
                                                  validator: (value) => null,
                                                  onChanged: (String value) {
                                                    updateTransactionTotal();
                                                  },
                                                )
                                            ),
                                          ),
                                          Expanded(
                                              child: Container(
                                                  padding: const EdgeInsets.only(left: 5),
                                                  child: TextFormField(
                                                    controller: taxesController,
                                                    textInputAction: TextInputAction.next,
                                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                                    inputFormatters: [_taxesFormatter],
                                                    decoration: InputDecoration(
                                                      labelText: feeText,
                                                    ),
                                                    validator: (value) => null,
                                                    onChanged: (String value) {
                                                      updateTransactionTotal();
                                                    },
                                                  )
                                              )
                                          ),
                                        ]
                                    )
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  child: TransactedAtDatepicker(onSelect: () {}),
                                ),
                                Container(
                                    margin: const EdgeInsets.symmetric(vertical: 15),
                                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                                    width: double.infinity,
                                    decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: const BorderRadius.all(Radius.circular(5))),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(totalText, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey[500])),
                                          Container(
                                            padding: const EdgeInsets.only(top: 10),
                                            child: Text(transactionTotal, style: Theme.of(context).textTheme.headlineMedium),
                                          ),
                                        ]
                                    )
                                ),
                                Container(
                                    margin: const EdgeInsets.symmetric(vertical: 15),
                                    child: ElevatedButton(
                                        onPressed: isFormReady(
                                            exchangesAutocompleteState.selectedExchange,
                                            coinsAutocompleteState.selectedCoin,
                                            amountController.text.replaceAll(',', '.'),
                                            _priceFormatter.getUnformattedValue().toString()
                                        ) ? () async {
                                          appState.context = context;
                                          await appState.addTransaction({
                                            "amount" : double.parse(amountController.text.replaceAll(',', '.')),
                                            "price" : double.parse(_priceFormatter.getUnformattedValue().toString()),
                                            "taxes" : double.parse(_taxesFormatter.getUnformattedValue().toString()),
                                            "transaction_type" : transactionTypeController.text,
                                            "coin" : coinsAutocompleteState.selectedCoin!.id,
                                            "exchange" : exchangesAutocompleteState.selectedExchange!.id,
                                            "transacted_at" : dateState.selectedDate
                                          });
                                          clearForm(exchangesAutocompleteState, coinsAutocompleteState, dateState);
                                        } : null,
                                        child: appState.addTransactionLoading == true
                                            ? const CircularProgressIndicator()
                                            : Text(buttonText)
                                    )
                                )
                              ]
                          )
                      )
                  )
              );
            }
        )
    );
  }
}