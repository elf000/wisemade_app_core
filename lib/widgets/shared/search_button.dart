import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../pages/coins_search.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          PersistentNavBarNavigator.pushDynamicScreen(
            context,
            screen: MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => const CoinsSearchPage()
            ),
            withNavBar: false,
          );
        },
        child: const Icon(Icons.search, size: 32)
    );
  }
}