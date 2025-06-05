import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'list_item.dart';

class ListSkeleton extends StatelessWidget {
  final int size;
  final double? height;

  const ListSkeleton({
    super.key,
    required this.size,
    this.height,
  });

  Widget buildShimmerLine(double width, {double height = 16}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(size, (index) {
        return ListItem(
          height: height,
          children: [
            buildShimmerLine(80),
            const SizedBox(height: 6),
            buildShimmerLine(140),
          ],
        );
      }),
    );
  }
}