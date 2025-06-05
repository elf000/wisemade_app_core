import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerThemeWrapper extends StatelessWidget {
  final Widget child;
  final bool enabled;

  const ShimmerThemeWrapper({
    super.key,
    required this.child,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    return Shimmer.fromColors(
      baseColor: const Color(0xFFF1F1F1),
      highlightColor: const Color(0xFFECECEC),
      child: child,
    );
  }
}