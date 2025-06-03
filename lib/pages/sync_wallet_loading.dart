import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'dart:async';

import 'package:wisemade_app_core/pages/app.dart';

class SyncWalletLoading extends StatefulWidget {
  const SyncWalletLoading({super.key});

  @override
  State<SyncWalletLoading> createState() => _SyncWalletLoadingState();
}

class _SyncWalletLoadingState extends State<SyncWalletLoading> {
  int _currentTextIndex = 0;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startDisplayingTexts();
  }

  void _startDisplayingTexts() {
    Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      final successMessageText = FlutterI18n.translate(context, 'add_wallet.success');

      _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
        if (_currentTextIndex < 3) {
          setState(() {
            _currentTextIndex++;
          });
        } else {
          _timer?.cancel();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const AppPage()),
                (Route<dynamic> route) => false,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(successMessageText),
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(20),
              elevation: 10,
            ),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> texts = [
      FlutterI18n.translate(context, 'add_wallet.loading.first'),
      FlutterI18n.translate(context, 'add_wallet.loading.second'),
      FlutterI18n.translate(context, 'add_wallet.loading.third'),
      FlutterI18n.translate(context, 'add_wallet.loading.fourth'),
    ];

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Text(
              texts[_currentTextIndex],
              key: ValueKey<int>(_currentTextIndex),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        )
      )
    );
  }
}