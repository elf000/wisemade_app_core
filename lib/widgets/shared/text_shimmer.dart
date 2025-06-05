import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TextSkeleton extends StatelessWidget {
  final dynamic text;
  final bool ready;
  final double width;
  final double height;
  final TextStyle? style;
  final Function? formatter;

  const TextSkeleton(
      this.text, {
        super.key, // ✅ Corrigido: super parameter
        required this.ready,
        required this.width,
        required this.height,
        this.style,
        this.formatter,
      });

  @override
  Widget build(BuildContext context) {
    if (ready) {
      return Text(
        formatter != null ? formatter!(text) : text.toString(),
        style: style,
      );
    }

    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
    );
  }
}