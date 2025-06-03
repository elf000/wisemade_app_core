import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wisemade_app_core/main.dart';

class ShareWithFriends extends StatefulWidget {
  const ShareWithFriends({
    Key? key,
  }) : super(key: key);

  @override
  State<ShareWithFriends> createState() => _ShareWithFriendsState();
}

class _ShareWithFriendsState extends State<ShareWithFriends> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appId = Platform.isAndroid ? 'io.wisemade.app' : '6443395548';
    final url = Platform.isAndroid
        ? "market://details?id=$appId"
        : "https://apps.apple.com/br/app/id$appId";

    final calloutText = FlutterI18n.translate(context, 'home.share_with_friends.callout');
    final messageText = FlutterI18n.translate(context, 'home.share_with_friends.message', translationParams: {'url': url});
    final buttonText = FlutterI18n.translate(context, 'home.share_with_friends.button');

    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(5)),
        child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        calloutText,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        mixpanel.track('Clicked on [Share With Friend]');

                        final box = context.findRenderObject() as RenderBox?;
                        Share.share(
                            messageText,
                            subject: 'Wisemade',
                            sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size
                        );
                      },
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.deepPurple)),
                      child: Text(buttonText),
                    )
                  ]
              )
            ),
            Image.asset('images/owl-singing.png', width: 130)
          ]
        )
      )
    );
  }
}