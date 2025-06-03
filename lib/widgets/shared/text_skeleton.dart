import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class TextSkeleton extends StatelessWidget {
  final dynamic text;
  final bool ready;
  final double width;
  final double height;

  final TextStyle? style;
  final Function? formatter;

  const TextSkeleton(
      this.text,
    {
      Key? key,
      required this.ready,
      required this.width,
      required this.height,
      this.style,
      this.formatter
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ready
        ? Text(formatter != null ? formatter!(text) : text, style: style)
        : SkeletonLine(style: SkeletonLineStyle(width: width, height: height));
  }
}
