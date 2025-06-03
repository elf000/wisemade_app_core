import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class SkeletonThemeProvider extends StatelessWidget {
  final Widget child;

  const SkeletonThemeProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SkeletonTheme(
      shimmerGradient: const LinearGradient(
        colors: [
          Color(0xFFF1F1F1),
          Color(0xFFE7E7E7),
          Color(0xFFECECEC),
        ],
        stops: [
          0.1,
          0.5,
          0.9,
        ],
      ),
      darkShimmerGradient: const LinearGradient(
        colors: [
          Color(0xFF24213F),
          Color(0xff28243f),
          Color(0xff292845),
          Color(0xff2a2948),
          Color(0xff27243f),
        ],
        stops: [
          0.0,
          0.2,
          0.5,
          0.8,
          1,
        ],
        begin: Alignment(-2.4, -0.2),
        end: Alignment(2.4, 0.2),
        tileMode: TileMode.clamp,
      ),
      child: child,
    );
  }
}
