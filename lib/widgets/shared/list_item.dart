import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class ListItem extends StatelessWidget {
  final List<Widget> children;
  final double? height;
  final double? padding;
  final VoidCallback? onTap;
  final String? orientation;
  final double? margin;
  final Function? onDismissed;

  bool? selected = false;

  ListItem({
    Key? key,
    required this.children,
    this.orientation,
    this.height,
    this.margin,
    this.padding,
    this.onTap,
    this.selected,
    this.onDismissed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final swipeToDeleteText = FlutterI18n.translate(context, 'shared.swipe_to_delete');
    final exclusionConfirmTitleText = FlutterI18n.translate(context, 'transactions.exclusion_confirm.title');
    final exclusionConfirmContentText = FlutterI18n.translate(context, 'transactions.exclusion_confirm.content');
    final exclusionConfirmYesText = FlutterI18n.translate(context, 'transactions.exclusion_confirm.yes');
    final exclusionConfirmCancelText = FlutterI18n.translate(context, 'transactions.exclusion_confirm.cancel');

    return Container(
      margin: EdgeInsets.fromLTRB(0, margin ?? 10, 0, 0),
      child: onDismissed != null ? Dismissible(
        key: Key("ListItemDismissible-${key!.toString()}"),
        background: Container(
          padding: const EdgeInsets.only(right: 10),
          decoration: const BoxDecoration(color: Colors.red),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(swipeToDeleteText, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)),
              const Icon(Icons.delete, color: Colors.white, size: 32)
            ]
          ),
        ),
        direction: DismissDirection.endToStart,
        confirmDismiss: (DismissDirection direction) async {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(exclusionConfirmTitleText),
                content: Text(exclusionConfirmContentText),
                actions: <Widget>[
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(exclusionConfirmYesText, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white))
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(exclusionConfirmCancelText, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)),
                  ),
                ],
              );
            },
          );
        },
        onDismissed: (_) => onDismissed!(),
        child: ListItemContent(onTap: onTap, height: height, padding: padding, selected: selected, orientation: orientation, children: children)
      ) : ListItemContent(onTap: onTap, height: height, padding: padding, selected: selected, orientation: orientation, children: children)
    );
  }
}

class ListItemContent extends StatelessWidget {
  const ListItemContent({
    super.key,
    required this.onTap,
    required this.height,
    required this.padding,
    required this.selected,
    required this.orientation,
    required this.children,
  });

  final VoidCallback? onTap;
  final double? height;
  final double? padding;
  final bool? selected;
  final String? orientation;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
            height: height,
            padding: EdgeInsets.all(padding ?? 20),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              color: selected == true
                  ? Colors.indigo[400]
                  : Theme.of(context).cardColor,
            ),
            child: orientation == 'vertical'
                ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children
            )
                : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children
            )
        )
    );
  }
}