import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class StatisticBar extends StatelessWidget {
  final num? value;
  final String leading;
  final String trailing;
  final String label;
  final bool fixedColor;

  static const Color blue = Color(0xFF174360);

  const StatisticBar({
    super.key,
    required this.value,
    required this.leading,
    required this.trailing,
    required this.label,
    this.fixedColor = false
  });

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
    return value != null ? LinearPercentIndicator(
        animation: true,
        animationDuration: 1000,
        lineHeight: 20.0,
        backgroundColor: Theme.of(context).cardColor,
        leading: Text(leading),
        trailing: Text(trailing),
        center: Text(label),
        percent: value! / 100,
        barRadius: const Radius.circular(10),
        progressColor: fixedColor ? blue : getColor(),
    ) : const SizedBox();
  }
}