import 'package:flutter/material.dart';

class BoxHeader extends StatelessWidget {
  const BoxHeader({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        child: child
    );
  }
}