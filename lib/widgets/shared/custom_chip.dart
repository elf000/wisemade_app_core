// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart' show clampDouble;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// A Material Design filter chip.
///
/// Filter chips use tags or descriptive words as a way to filter content.
///
/// Filter chips are a good alternative to [Checkbox] or [Switch] widgets.
/// Unlike these alternatives, filter chips allow for clearly delineated and
/// exposed options in a compact area.
///
/// Requires one of its ancestors to be a [Material] widget.
///
/// {@tool dartpad}
/// This example shows how to use [CustomChip]s to filter through exercises.
///
/// ** See code in examples/api/lib/material/filter_chip/filter_chip.0.dart **
/// {@end-tool}
///
/// ## Material Design 3
///
/// [CustomChip] can be used for multiple select Filter chip from
/// Material Design 3. If [ThemeData.useMaterial3] is true, then [CustomChip]
/// will be styled to match the Material Design 3 specification for Filter
/// chips. Use [ChoiceChip] for single select Filter chips.
///
/// See also:
///
///  * [Chip], a chip that displays information and can be deleted.
///  * [InputChip], a chip that represents a complex piece of information, such
///    as an entity (person, place, or thing) or conversational text, in a
///    compact form.
///  * [ChoiceChip], allows a single selection from a set of options. Choice
///    chips contain related descriptive text or categories.
///  * [ActionChip], represents an action related to primary content.
///  * [CircleAvatar], which shows images or initials of people.
///  * [Wrap], A widget that displays its children in multiple horizontal or
///    vertical runs.
///  * <https://material.io/design/components/chips.html>
class CustomChip extends StatelessWidget
    implements
        ChipAttributes,
        SelectableChipAttributes,
        CheckmarkableChipAttributes,
        DisabledChipAttributes {
  /// Create a chip that acts like a checkbox.
  ///
  /// The [selected], [label], [autofocus], and [clipBehavior] arguments must
  /// not be null. The [pressElevation] e [elevation] devem ser nulos ou não-negativos.
  const CustomChip({
    super.key,
    this.avatar,
    required this.label,
    this.labelStyle,
    this.labelPadding,
    this.selected = false,
    required this.onSelected,
    this.pressElevation,
    this.disabledColor,
    this.selectedColor,
    this.tooltip,
    this.side,
    this.shape,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    this.backgroundColor,
    this.padding,
    this.visualDensity,
    this.materialTapTargetSize,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.iconTheme,
    this.selectedShadowColor,
    this.showCheckmark,
    this.checkmarkColor,
    this.avatarBorder = const CircleBorder(),
    this.onDeleted,
  }) : assert(selected != null),
        assert(label != null),
        assert(clipBehavior != null),
        assert(autofocus != null),
        assert(pressElevation == null || pressElevation >= 0.0),
        assert(elevation == null || elevation >= 0.0);

  @override
  final Widget? avatar;
  @override
  final Widget label;
  @override
  final TextStyle? labelStyle;
  @override
  final EdgeInsetsGeometry? labelPadding;
  @override
  final bool selected;
  @override
  final ValueChanged<bool>? onSelected;
  @override
  final double? pressElevation;
  @override
  final Color? disabledColor;
  @override
  final Color? selectedColor;
  @override
  final String? tooltip;
  @override
  final BorderSide? side;
  @override
  final OutlinedBorder? shape;
  @override
  final Clip clipBehavior;
  @override
  final FocusNode? focusNode;
  @override
  final bool autofocus;
  @override
  final Color? backgroundColor;
  @override
  final EdgeInsetsGeometry? padding;
  @override
  final VisualDensity? visualDensity;
  @override
  final MaterialTapTargetSize? materialTapTargetSize;
  @override
  final double? elevation;
  @override
  final Color? shadowColor;
  @override
  final Color? surfaceTintColor;
  @override
  final Color? selectedShadowColor;
  @override
  final bool? showCheckmark;
  @override
  final Color? checkmarkColor;
  @override
  final ShapeBorder avatarBorder;
  @override
  final IconThemeData? iconTheme;

  final Function? onDeleted;

  @override
  bool get isEnabled => onSelected != null;

  /// *** Implementações adicionadas para satisfazer `ChipAttributes` ***
  @override
  BoxConstraints? get avatarBoxConstraints => null;

  @override
  ChipAnimationStyle? get chipAnimationStyle => null;

  @override
  MouseCursor? get mouseCursor => null;

  @override
  MaterialStateProperty<Color?>? get color => throw UnimplementedError();

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    final ChipThemeData? defaults = Theme.of(context).useMaterial3
        ? _FilterChipDefaultsM3(context, isEnabled, selected)
        : null;
    return RawChip(
      deleteIcon: const Icon(Icons.close, color: Colors.black54),
      onDeleted: onDeleted != null
          ? () {
        onDeleted!();
      }
          : null,
      defaultProperties: defaults,
      avatar: avatar,
      label: label,
      labelStyle: labelStyle,
      labelPadding: labelPadding,
      onSelected: onSelected,
      pressElevation: pressElevation,
      selected: selected,
      tooltip: tooltip,
      side: side,
      shape: shape,
      clipBehavior: clipBehavior,
      focusNode: focusNode,
      autofocus: autofocus,
      backgroundColor: backgroundColor,
      disabledColor: disabledColor,
      selectedColor: selectedColor,
      padding: padding,
      visualDensity: visualDensity,
      isEnabled: isEnabled,
      materialTapTargetSize: materialTapTargetSize,
      elevation: elevation,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      selectedShadowColor: selectedShadowColor,
      showCheckmark: showCheckmark,
      checkmarkColor: checkmarkColor,
      avatarBorder: avatarBorder,
    );
  }
}


// BEGIN GENERATED TOKEN PROPERTIES - FilterChip

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// Token database version: v0_143

class _FilterChipDefaultsM3 extends ChipThemeData {
  const _FilterChipDefaultsM3(this.context, this.isEnabled, this.isSelected)
      : super(
    elevation: 0.0,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
    showCheckmark: true,
  );

  final BuildContext context;
  final bool isEnabled;
  final bool isSelected;

  @override
  TextStyle? get labelStyle => Theme.of(context).textTheme.labelLarge;

  @override
  Color? get backgroundColor => null;

  @override
  Color? get shadowColor => Theme.of(context).colorScheme.shadow;

  @override
  Color? get surfaceTintColor => Theme.of(context).colorScheme.surfaceTint;

  @override
  Color? get selectedColor => isEnabled
      ? Theme.of(context).colorScheme.secondaryContainer
      : Theme.of(context).colorScheme.onSurface.withOpacity(0.12);

  @override
  Color? get checkmarkColor => Theme.of(context).colorScheme.onSecondaryContainer;

  @override
  Color? get disabledColor => isSelected
      ? Theme.of(context).colorScheme.onSurface.withOpacity(0.12)
      : null;

  @override
  Color? get deleteIconColor => Theme.of(context).colorScheme.onSecondaryContainer;

  @override
  BorderSide? get side => !isSelected
      ? isEnabled
      ? BorderSide(color: Theme.of(context).colorScheme.outline)
      : BorderSide(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12))
      : const BorderSide(color: Colors.transparent);

  @override
  IconThemeData? get iconTheme => IconThemeData(
    color: isEnabled
        ? null
        : Theme.of(context).colorScheme.onSurface,
    size: 18.0,
  );

  @override
  EdgeInsetsGeometry? get padding => const EdgeInsets.all(8.0);

  /// The chip at text scale 1 starts with 8px on each side and as text scaling
  /// gets closer to 2 the label padding is linearly interpolated from 8px to 4px.
  /// Once the widget has a text scaling of 2 or higher than the label padding
  /// remains 4px.
  @override
  EdgeInsetsGeometry? get labelPadding => EdgeInsets.lerp(
    const EdgeInsets.symmetric(horizontal: 8.0),
    const EdgeInsets.symmetric(horizontal: 4.0),
    clampDouble(MediaQuery.of(context).textScaleFactor - 1.0, 0.0, 1.0),
  )!;
}

// END GENERATED TOKEN PROPERTIES - FilterChip
