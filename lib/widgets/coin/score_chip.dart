import 'package:flutter/material.dart';

import '../shared/custom_chip.dart';

class ScoreChip extends StatelessWidget {
  final num? value;

  const ScoreChip({
    super.key,
    required this.value,
  });

  String getLabel() {
    if(value! > 60) {
      return 'Bullish';
    } else if(value! < 40) {
      return 'Bearish';
    } else {
      return 'Neutral';
    }
  }

  IconData getIcon() {
    if(value! > 60) {
      return Icons.arrow_drop_up;
    } else if(value! < 40) {
      return Icons.arrow_drop_down;
    } else {
      return Icons.sentiment_neutral_sharp;
    }
  }

  Color getColor() {
    if(value! > 60) {
      return Colors.green;
    } else if(value! < 40) {
      return Colors.red;
    } else {
      return Colors.white;
    }
  }

  Color getBackground() {
    if(value! > 60) {
      return Colors.green;
    } else if(value! < 40) {
      return Colors.red;
    } else {
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return value != null ? CustomChip(
      side: BorderSide(color: Theme.of(context).cardColor, width: 1),
      backgroundColor: const Color(0xFF201B2D),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      label: Text("Score $value/100", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xFFFFE8AC))),
      onSelected: (bool value) {  },
    ) : const SizedBox();
  }
}