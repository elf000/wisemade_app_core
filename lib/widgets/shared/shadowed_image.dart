import 'package:flutter/material.dart';

Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

class ShadowedImage extends StatelessWidget {
  final int color;
  final Alignment alignment;

  const ShadowedImage({
    Key? key,
    this.color = 0x00000000,
    this.alignment = Alignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Image.asset(
              'images/landing-screen-image.png',
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
              alignment: alignment,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  darken(Color(color + 0xCC000000), .6),
                  Color(color + 0x66000000),
                  darken(Color(color + 0xCA000000), .3),
                  darken(Color(color + 0xDA000000), .7),
                ],
              ),
            ),
          )
        ]
    );
  }
}