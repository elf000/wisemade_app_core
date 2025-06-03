import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

import '../../app_state.dart';
import '../../models/asset_holder.dart';
import '../shared/filter_chips_carousel.dart';

class CockpitHeader extends StatefulWidget {
  final Function onExchangeChange;

  const CockpitHeader({
    Key? key,
    required this.onExchangeChange
  }) : super(key: key);

  @override
  State<CockpitHeader> createState() => _CockpitHeaderState();
}

class _CockpitHeaderState extends State<CockpitHeader> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, child) {
        List<AssetHolder> assetHolders = state.assetHolders;
        num? selectedPortfolioExchangeId = state.selectedAssetHolder?.id;

        final generalText = FlutterI18n.translate(context, 'portfolio.general');
        final confirmExclusionTitleText = FlutterI18n.translate(context, 'portfolio.exclusion_confirm.title');
        final confirmExclusionContentText = FlutterI18n.translate(context, 'portfolio.exclusion_confirm.content');
        final confirmExclusionYesText = FlutterI18n.translate(context, 'portfolio.exclusion_confirm.yes');
        final confirmExclusionCancelText = FlutterI18n.translate(context, 'portfolio.exclusion_confirm.cancel');

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            state.assetHoldersLoading == false
                ? FilterChipsCarousel(
                selected: selectedPortfolioExchangeId,
                options: [
                  { 'label': generalText, 'value': null },
                  ...assetHolders.map((ep) => { 'label' : ep.displayName, 'value' : ep.id, 'images' : ep.imageUrls, 'type' : ep.type }).toList(),
                ],
                onSelect: (option) => setState(() {
                  state.selectAssetHolder(assetHolders.where((ah) => ah.id == int.tryParse(option ?? '')).firstOrNull);
                  widget.onExchangeChange();
                }),
                chipPadding: const EdgeInsets.symmetric(horizontal: 10),
                onDeleted: (value, type) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(confirmExclusionTitleText),
                        content: Text(confirmExclusionContentText),
                        actions: [
                          TextButton(
                              onPressed: () {
                                state.deleteAssetHolder(value, type: type);
                                Navigator.of(context).pop();
                              },
                              child: Text(confirmExclusionYesText, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white))),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(confirmExclusionCancelText, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)))
                        ],
                      );
                    });
                  },
                )
                : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: const SkeletonLine(style: SkeletonLineStyle(width: 80, height: 25)),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: const SkeletonLine(style: SkeletonLineStyle(width: 180, height: 25)),
                        )
                      ]
                  )
                ),
          ],
        );
      }
    );
  }
}
