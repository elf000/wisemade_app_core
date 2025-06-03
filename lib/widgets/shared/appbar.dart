import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:wisemade_app_core/pages/profile.dart';
import 'package:wisemade_app_core/widgets/shared/nft_avatar.dart';
import 'package:wisemade_app_core/widgets/shared/search_button.dart';

import '../../app_state.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final dynamic? title;
  final bool withLogo;
  final bool withAvatar;
  final bool withSearch;
  final bool center;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    required this.preferredSize,
    this.withLogo = false,
    this.withAvatar = false,
    this.withSearch = false,
    this.center = false,
    this.title,
    this.bottom
  });

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {


    return AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      titleSpacing: 20,
      centerTitle: center,
      title: getTitle(context),
      elevation: 0,
      actions: [],
      bottom: bottom,
      scrolledUnderElevation: 0,
    );
  }

  Widget getTitle(BuildContext context) {
    AppState appState = Provider.of<AppState>(context, listen: false);

    if (title != null) {
        return Row(
          children: [
            if(withAvatar == true) ...[
              GestureDetector(
                onTap: () async {
                  PersistentNavBarNavigator.pushDynamicScreen(
                    context!,
                    screen: MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => const ProfilePage(),
                    ),
                    withNavBar: false,
                  );
                },
                child: const NFTAvatar(size: 42),
              ),
              const SizedBox(width: 20),
            ],
            title is Widget ? title : Text(title ?? '', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20)),
            if(withSearch == true) const Expanded(
                child: Align(
                    alignment: Alignment.centerRight,
                    child: SearchButton()
                )
            )
          ],
        );
    }

    return Image.asset('images/logo-text-white.png', height: 18, alignment: Alignment.center);
  }
}