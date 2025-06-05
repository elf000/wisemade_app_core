import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CarouselSkeleton extends StatelessWidget {
  final int length;
  final double height;
  final double width;

  const CarouselSkeleton({
    super.key,
    required this.length,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(5),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade800,
            highlightColor: Colors.grey.shade600,
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        );
      },
    );
  }
}