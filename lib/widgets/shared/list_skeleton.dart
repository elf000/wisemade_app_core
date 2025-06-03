import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

import 'list_item.dart';

class ListSkeleton extends StatelessWidget {
  final int size;
  final double? height;

  const ListSkeleton({
    Key? key,
    required this.size,
    this.height
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.filled(size, null).map((i) =>
        ListItem(
          height: height,
          children: const [
            SkeletonLine(style: SkeletonLineStyle(width: 80)),
            SkeletonLine(style: SkeletonLineStyle(width: 140))
          ]
        )
      ).toList()
    );
  }
}
