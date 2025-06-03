import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart'; // este é o import correto

import '../../pages/add_connection.dart';

class AddCoinBox extends StatelessWidget {
  const AddCoinBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleText = FlutterI18n.translate(context, 'portfolio.add_token');

    return InkWell(
      onTap: () {
        PersistentNavBarNavigator.pushDynamicScreen(
          context,
          screen: MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => const AddResource(),
          ),
          withNavBar: false,
        );
      },
      child: Container(
        width: 180,
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(20),
        decoration: DottedDecoration(
          shape: Shape.box,
          color: Colors.lightGreen,
          strokeWidth: 2,
          borderRadius: BorderRadius.circular(12),
          dash: const [12, 8, 11, 6],
        ),
        child: Center(
          child: Text(
            titleText,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
    );
  }
}