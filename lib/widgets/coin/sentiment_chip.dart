import 'package:flutter/material.dart';

import '../shared/custom_chip.dart';

class SentimentChip extends StatelessWidget {
  final num? value;

  const SentimentChip({
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
      return const Color(0xFF274239);
    } else if(value! < 40) {
      return const Color(0xFF652323);
    } else {
      return const Color(0xFF7C6112);
    }
  }

  @override
  Widget build(BuildContext context) {
    return value != null ? CustomChip(
      side: BorderSide(color: getColor(), width: 1),
      backgroundColor: getColor(),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      label: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 5),
            child: Icon(getIcon())
          ),
          Text(getLabel(), style: Theme.of(context).textTheme.bodyMedium)
        ]
      ),
      onSelected: (bool value) {  },
    ) : const SizedBox();
  }
}