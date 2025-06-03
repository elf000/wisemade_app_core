
import 'package:flutter/material.dart';
import 'package:wisemade_app_core/widgets/shared/custom_chip.dart';

import 'image_stack.dart';

class FilterChipsCarousel extends StatelessWidget {
  final dynamic selected;
  final List<Map<String, dynamic>> options;
  final Function onSelect;
  final Function? onDeleted;
  final EdgeInsets? chipPadding;

  const FilterChipsCarousel({
    super.key,
    required this.options,
    required this.onSelect,
    required this.selected,
    this.chipPadding,
    this.onDeleted
  });

  @override
  Widget build(BuildContext context) {
    return options.isNotEmpty ? Container(
        margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
        height: 50,
        child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 5, 0),
                child: ChipItem(
                  label: options[0]['label']!,
                  value: options[0]['value']?.toString(),
                  selected: selected == options[0]['value'],
                  onSelect: onSelect,
                  onDeleted: onDeleted != null ? () { onDeleted!(options[0]['value'], options[0]['type']); } : null,
                  padding: chipPadding,
                  imageUrls: options[0]['images'],
                ),
              ),
              ...options.getRange(1, options.length - 1).map<Widget>((Map<String, dynamic> option) => Container(
                margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: ChipItem(
                  label: option['label']!,
                  value: option['value']?.toString(),
                  selected: selected == option['value'],
                  onSelect: onSelect,
                  onDeleted: onDeleted != null ? () { onDeleted!(option['value'], option['type']); } : null,
                  padding: chipPadding,
                  imageUrls: option['images'],
                  withDeleteIcon: selected == option['value'],
                ),
              )).toList(),
              Container(
                margin: const EdgeInsets.fromLTRB(5, 0, 20, 0),
                child: ChipItem(
                  label: options[options.length - 1]['label']!,
                  value: options[options.length - 1]['value']?.toString(),
                  selected: selected == options[options.length - 1]['value'],
                  onSelect: onSelect,
                  onDeleted: onDeleted != null ? () {  onDeleted!(options[options.length - 1]['value'], options[options.length - 1]['type']); } : null,
                  padding: chipPadding,
                  imageUrls: options[options.length - 1]['images'],
                  withDeleteIcon: selected == options[options.length - 1]['value'],
                ),
              ),
            ]
        )
    ) : const SizedBox();
  }
}

class ChipItem extends StatelessWidget {
  final String label;
  final String? value;
  final Function onSelect;
  final bool selected;
  final EdgeInsets? padding;
  final List<String>? imageUrls;
  final Function? onDeleted;
  final bool? withDeleteIcon;

  const ChipItem({
    super.key,
    required this.label,
    required this.value,
    required this.onSelect,
    required this.selected,
    this.padding,
    this.imageUrls,
    this.onDeleted,
    this.withDeleteIcon
  });

  @override
  Widget build(BuildContext context) {
    return CustomChip(
      side: BorderSide(color: Theme.of(context).cardColor, width: 1),
      backgroundColor: Theme.of(context).cardColor,
      padding: padding,
      avatar: imageUrls != null ? StackedImages(images: imageUrls!) : null,
      showCheckmark: imageUrls == null,
      label: Text(label),
      onSelected: (val) => onSelect(value),
      selected: selected,
      selectedColor: Theme.of(context).colorScheme.secondary,
      onDeleted: withDeleteIcon == true ? onDeleted : null
    );
  }
}

class StackedImages extends StatelessWidget {
  final List<String> images;

  const StackedImages({
    super.key,
    required this.images
  });

  @override
  Widget build(BuildContext context) {
    return ImageStack(
      imageList: images,
      showTotalCount: false,
      totalCount: images.length,
      itemRadius: 22,
      itemCount: 3,
      itemBorderWidth: 0,
      backgroundColor: Theme.of(context).cardColor,
      itemBorderColor: Theme.of(context).cardColor,
    );
  }
}
