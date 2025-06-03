import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_state.dart';

class NFTAvatar extends StatefulWidget {
  final double size;
  final double? borderRadius;

  const NFTAvatar({
    Key? key,
    required this.size,
    this.borderRadius
  }) : super(key: key);

  @override
  State<NFTAvatar> createState() => _NFTAvatarState();
}

class _NFTAvatarState extends State<NFTAvatar> {

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        Widget Placeholder = ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 5),
            child: Image.asset('images/launcher-icon.png', width: widget.size)
        );


        if(appState.avatarMetadata?['image'] != null) {
          String image = appState.avatarMetadata?['image'];
          String url = "https://ipfs.io/ipfs/${image.substring(7, image.length)}";
          return ClipRRect(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 5),
              child: CachedNetworkImage(imageUrl: url, width: widget.size, placeholder: (context, url) => Placeholder)
          );
        }

        return Placeholder;

      },
    );
  }
}