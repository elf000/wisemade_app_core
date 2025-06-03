import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class CarouselSkeleton extends StatelessWidget {
  final int length;
  final double height;
  final double width;

  const CarouselSkeleton({
    Key? key,
    required this.length,
    required this.height,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: List.filled(length, null).map((i) =>
        Container(
          margin: const EdgeInsets.all(5),
          child: SkeletonLine(style: SkeletonLineStyle(width: width, height: height))
        )
      ).toList()
    );
  }
}
