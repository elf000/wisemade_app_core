import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Percentage extends StatelessWidget {
  final double value;
  final TextStyle? style;
  final MainAxisAlignment alignment;
  final double iconSize;

  const Percentage({
    Key? key,
    required this.value,
    this.style,
    this.iconSize = 14.0,
    this.alignment = MainAxisAlignment.end
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final f = NumberFormat("#,##0.00", "pt_BR");
    return Row(
      mainAxisAlignment: alignment,
      children: [
        Icon(
          value >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
          color: value >= 0 ? Colors.green : Colors.red,
          size: iconSize
        ),
        Text(
            "${f.format(value.abs())} %",
            style: (style ?? const TextStyle()).merge(TextStyle(
                color: value >= 0
                    ? Colors.greenAccent[700]
                    : Colors.red
            ))
        )
      ]
    );
  }
}