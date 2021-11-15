import 'package:flutter/material.dart';

import '../../../../core/extension/context_extension.dart';

class CounterButton extends ElevatedButton {
  CounterButton({
    required BuildContext context,
    required IconData iconData,
    Function()? onPressed,
  }) : super(
          style: _style(context),
          onPressed: onPressed,
          child: _child(iconData, context),
        );

  static ButtonStyle _style(BuildContext context) {
    return ElevatedButton.styleFrom(
        onPrimary: Colors.transparent,
        fixedSize: Size(context.dynamicWidth(0.5), context.dynamicHeight(0.2)),
        primary: Colors.transparent,
        shadowColor: Colors.transparent,
        side: BorderSide.none);
  }

  static Icon _child(IconData iconData, BuildContext context) {
    return Icon(
      iconData,
      size: 50,
      color: context.colorScheme.secondary,
    );
  }
}
