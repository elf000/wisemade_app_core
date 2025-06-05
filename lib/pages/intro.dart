import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wisemade_app_core/pages/auth.dart';

import '../main.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final PageController controller = PageController(keepPage: true);
  double pageOffset = 0;

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      mixpanel.track('Selected Step', properties: { 'step' : controller.page });
      setState(() => pageOffset = controller.page ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    mixpanel.track('Viewed Screen - Intro');
    List<Widget> steps = getSteps(context);

    final buttonText = FlutterI18n.translate(context, 'shared.continue');

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('images/logo-text-white.png', height: 20),
                    Expanded(
                      flex: 1,
                      child: PageView(
                        controller: controller,
                        children: steps
                      )
                    ),
                    Container(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: SmoothPageIndicator(
                          controller: controller,
                          count: steps.length,
                          effect: const WormEffect(
                            dotHeight: 10,
                            dotWidth: 10,
                            type: WormType.thin,
                            // strokeWidth: 5,
                          ),
                        )
                    ),
                    ElevatedButton(
                        onPressed: () => {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const AuthPage()))
                        },
                        child: Text(
                          buttonText,
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        )
                    )
                  ]
                )
              )
            )
      );
  }

  List<Widget> getSteps(BuildContext context) {
    final step1HeadlineText = FlutterI18n.translate(context, 'intro.steps.first.headline');
    final step1DescriptionText = FlutterI18n.translate(context, 'intro.steps.first.description');
    final step2HeadlineText = FlutterI18n.translate(context, 'intro.steps.second.headline');
    final step2DescriptionText = FlutterI18n.translate(context, 'intro.steps.second.description');
    final step3HeadlineText = FlutterI18n.translate(context, 'intro.steps.third.headline');
    final step3DescriptionText = FlutterI18n.translate(context, 'intro.steps.third.description');

    return [
      Step(
          offset: pageOffset - 1,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Image.asset('images/owl-with-bitcoin.png', width: 180),
              )
            ),
            Text(
              step1HeadlineText,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
                fontWeight: FontWeight.w600
              )
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text(
                  step1DescriptionText,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.normal)
              )
            )
          ]
      ),
      Step(
          offset: pageOffset - 2,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Image.asset('images/owl-with-cryptos.png', width: 200),
              )
            ),
            Text(
                step2HeadlineText,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                    fontWeight: FontWeight.w600
                )
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text(
                  step2DescriptionText,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.normal)
              )
            )
          ]
      ),
      Step(
          offset: pageOffset - 3,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Image.asset('images/owl-with-crypto-and-chart.png', width: 200),
              )
            ),
            Column(
              children: [
                Text(
                    step3HeadlineText,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                        fontWeight: FontWeight.w600
                    )
                ),
                Container(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Text(
                        step3DescriptionText,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.normal)
                    )
                )
              ]
            )
          ]
      ),
    ];
  }
}

class Step extends StatelessWidget {
  const Step({
    super.key,
    required this.offset,
    required this.children,
  });

  final double offset;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    double gauss = exp(-(pow((offset.abs() - 0.5), 2) / 0.08));

    return Transform.translate(
      offset: Offset(64 * gauss, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children,
      ),
    );
  }
}