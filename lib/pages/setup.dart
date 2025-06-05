import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wisemade_app_core/widgets/shared/list_item.dart';

import '../app_state.dart';
import '../main.dart';


class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  final PageController controller = PageController(keepPage: true);

  Map<String, int?> values = { 'age' : null, 'invested_amount_12_months' : null, 'patrimony_size' : null, 'crypto_knowledge' : null };
  double pageOffset = 0;

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      setState(() => pageOffset = controller.page ?? 0);
    });

    AppState appState = Provider.of<AppState>(context, listen: false);
    appState.getCurrentUser();
  }

  void setValue(id, value) {
    setState(() {
      values[id] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> steps = getSteps(context, setValue);
    final titleText = FlutterI18n.translate(context, 'setup.title');

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Container(
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  child: Image.asset('images/owl-with-pencil-and-paper.png', width: 200),
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: steps.length,
                      effect: const WormEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        type: WormType.thin,
                        // strokeWidth: 5,
                      ),
                    )
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                        titleText,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.shadow,
                        )
                    )
                ),
                ExpandablePageView(
                  controller: controller,
                  children: steps
                ),
              ]
            )
          )
      )
    );
  }

  List<Widget> getSteps(BuildContext context, Function setValue) {
    final ageQuestionText = FlutterI18n.translate(context, 'setup.steps.age.question');
    final investedAmount12MonthsQuestionText = FlutterI18n.translate(context, 'setup.steps.invested_amount_12_months.question');
    final patrimonySizeQuestionText = FlutterI18n.translate(context, 'setup.steps.patrimony_size.question');
    final cryptoKnowledgeQuestionText = FlutterI18n.translate(context, 'setup.steps.crypto_knowledge.question');
    final riskLevelQuestionText = FlutterI18n.translate(context, 'setup.steps.risk_level.question');

    return [
      Step(
        value: values['age'],
        questionId: 'age',
        onSelectOption: (value) {
          controller.animateToPage(1, duration: const Duration(milliseconds: 200), curve: Curves.linear);
          setValue('age', value);
        },
        children: [
          Text(
              ageQuestionText,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.outline,
              fontWeight: FontWeight.w600
            )
          ),
        ]
      ),
      Step(
        value: values['invested_amount_12_months'],
        questionId: 'invested_amount_12_months',
        onSelectOption: (value) {
          controller.animateToPage(2, duration: const Duration(milliseconds: 200), curve: Curves.linear);
          setValue('invested_amount_12_months', value);
        },
        children: [
          Text(
            investedAmount12MonthsQuestionText,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
                fontWeight: FontWeight.w600
            )
          ),
        ]
      ),
      Step(
        value: values['patrimony_size'],
        questionId: 'patrimony_size',
        onSelectOption: (value) {
          controller.animateToPage(3, duration: const Duration(milliseconds: 200), curve: Curves.linear);
          setValue('patrimony_size', value);
        },
        children: [
          Text(
            patrimonySizeQuestionText,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
                fontWeight: FontWeight.w600
            )
          ),
        ]
      ),
      Step(
        value: values['crypto_knowledge'],
        questionId: 'crypto_knowledge',
        onSelectOption: (value) {
          controller.animateToPage(4, duration: const Duration(milliseconds: 200), curve: Curves.linear);
          setValue('crypto_knowledge', value);
        },
        children: [
          Text(
            cryptoKnowledgeQuestionText,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
                fontWeight: FontWeight.w600
            )
          )
        ]
      ),
      Step(
        value: values['risk_level'],
        questionId: 'risk_level',
        onSelectOption: (value) {
          AppState appState = Provider.of<AppState>(context, listen: false);
          appState.context = context;
          appState.setupUser({ ...values, 'risk_level' : value });

          mixpanel.getPeople().set('age', values['age']);
          mixpanel.getPeople().set('invested_amount_12_months', values['invested_amount_12_months']);
          mixpanel.getPeople().set('patrimony_size', values['patrimony_size']);
          mixpanel.getPeople().set('crypto_knowledge', values['crypto_knowledge']);
          mixpanel.getPeople().set('risk_level', value);

          setValue('risk_level', value);
        },
        children: [
          Text(
              riskLevelQuestionText,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                  fontWeight: FontWeight.w600
              )
          )
        ]
      ),
    ];
  }
}

class Step extends StatelessWidget {
  final String questionId;
  final Function onSelectOption;
  final int? value;

  const Step({
    Key? key,
    required this.children,
    required this.questionId,
    required this.onSelectOption,
    required this.value
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context, listen: false);
    final fiatSymbol = appState.currentUser?.fiatPrefix ?? "\$";

    final List<Map<String, dynamic>> questions = [
      {
        'id' : 'age',
        'alternatives' : [
          { 'value' : 1, 'label' : FlutterI18n.translate(context, 'setup.steps.age.alternatives.first') },
          { 'value' : 2, 'label' : FlutterI18n.translate(context, 'setup.steps.age.alternatives.second') },
          { 'value' : 3, 'label' : FlutterI18n.translate(context, 'setup.steps.age.alternatives.third') },
          { 'value' : 4, 'label' : FlutterI18n.translate(context, 'setup.steps.age.alternatives.fourth') },
        ]
      },
      {
        'id' : 'invested_amount_12_months',
        'alternatives' : [
          { 'value' : 1, 'label' : FlutterI18n.translate(context, 'setup.steps.invested_amount_12_months.alternatives.first', translationParams: { 'symbol' : fiatSymbol }) },
          { 'value' : 2, 'label' : FlutterI18n.translate(context, 'setup.steps.invested_amount_12_months.alternatives.second', translationParams: { 'symbol' : fiatSymbol }) },
          { 'value' : 3, 'label' : FlutterI18n.translate(context, 'setup.steps.invested_amount_12_months.alternatives.third', translationParams: { 'symbol' : fiatSymbol }) },
          { 'value' : 4, 'label' : FlutterI18n.translate(context, 'setup.steps.invested_amount_12_months.alternatives.fourth', translationParams: { 'symbol' : fiatSymbol }) },
          { 'value' : 5, 'label' : FlutterI18n.translate(context, 'setup.steps.invested_amount_12_months.alternatives.fifth', translationParams: { 'symbol' : fiatSymbol }) },
        ]
      },
      {
        'id' : 'patrimony_size',
        'alternatives' : [
          { 'value' : 1, 'label' : FlutterI18n.translate(context, 'setup.steps.patrimony_size.alternatives.first', translationParams: { 'symbol' : fiatSymbol }) },
          { 'value' : 2, 'label' : FlutterI18n.translate(context, 'setup.steps.patrimony_size.alternatives.second', translationParams: { 'symbol' : fiatSymbol }) },
          { 'value' : 3, 'label' : FlutterI18n.translate(context, 'setup.steps.patrimony_size.alternatives.third', translationParams: { 'symbol' : fiatSymbol }) },
          { 'value' : 4, 'label' : FlutterI18n.translate(context, 'setup.steps.patrimony_size.alternatives.fourth', translationParams: { 'symbol' : fiatSymbol }) },
          { 'value' : 5, 'label' : FlutterI18n.translate(context, 'setup.steps.patrimony_size.alternatives.fifth', translationParams: { 'symbol' : fiatSymbol }) },
        ]
      },
      {
        'id' : 'crypto_knowledge',
        'alternatives' : [
          { 'value' : 1, 'label' : FlutterI18n.translate(context, 'setup.steps.crypto_knowledge.alternatives.first') },
          { 'value' : 2, 'label' : FlutterI18n.translate(context, 'setup.steps.crypto_knowledge.alternatives.second') },
          { 'value' : 3, 'label' : FlutterI18n.translate(context, 'setup.steps.crypto_knowledge.alternatives.third') },
          { 'value' : 4, 'label' : FlutterI18n.translate(context, 'setup.steps.crypto_knowledge.alternatives.fourth') },
          { 'value' : 5, 'label' : FlutterI18n.translate(context, 'setup.steps.crypto_knowledge.alternatives.fifth') },
        ]
      },
      {
        'id' : 'risk_level',
        'alternatives' : [
          { 'value' : 1, 'label' : FlutterI18n.translate(context, 'setup.steps.risk_level.alternatives.first') },
          { 'value' : 2, 'label' : FlutterI18n.translate(context, 'setup.steps.risk_level.alternatives.second') },
          { 'value' : 3, 'label' : FlutterI18n.translate(context, 'setup.steps.risk_level.alternatives.third') },
          { 'value' : 4, 'label' : FlutterI18n.translate(context, 'setup.steps.risk_level.alternatives.fourth') },
          { 'value' : 5, 'label' : FlutterI18n.translate(context, 'setup.steps.risk_level.alternatives.fifth') },
        ]
      },
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...children,
          ...questions
              .firstWhere((element) => element['id'] == questionId)['alternatives']
              .map((alternative) => ListItem(
                selected: value == alternative['value'],
                children: [
                  Text(alternative['label'])
                ],
                onTap: () {
                  onSelectOption(alternative['value']);
                },
              )).toList()
        ]
      )
    );
  }
}