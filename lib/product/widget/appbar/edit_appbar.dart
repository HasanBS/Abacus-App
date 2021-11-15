import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../../core/extension/context_extension.dart';
import '../../../core/constants/image/image_constatns.dart';

class EditAppBar extends AppBar {
  EditAppBar({
    required BuildContext context,
    required String title,
    required bool onEdit,
    required String editTitle,
    required String saveTitle,
    Function()? onPressed,
  }) : super(
          title: _title(title, context),
          leading: _leading(context),
          bottom: _bottom(context),
          actions: _action(context, onPressed, onEdit, saveTitle, editTitle),
        );

  static AutoSizeText _title(String title, BuildContext context) {
    return AutoSizeText(
      title,
      style: context.textTheme.headline6,
    );
  }

  static IconButton _leading(BuildContext context) {
    return IconButton(
      icon: Icon(
        ImageConstants.instance.backArrow,
        color: context.colorScheme.secondary,
      ),
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      onPressed: () {
        Navigator.maybePop(context);
      },
    );
  }

  static PreferredSize _bottom(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(0.5),
      child: Container(
        width: context.dynamicWidth(0.9),
        color: context.colorScheme.secondary,
        height: 0.5,
      ),
    );
  }

  static List<Widget> _action(BuildContext context, Function()? onPressed, bool onEdit,
      String saveTitle, String editTitle) {
    return [
      Padding(
        padding: context.horizontalPaddingMedium,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              side: BorderSide.none,
              shadowColor: Colors.transparent,
              primary: context.colorScheme.primary),
          child: AutoSizeText(
            onEdit ? saveTitle : editTitle,
            style: context.textTheme.headline6,
          ),
        ),
      ),
    ];
  }
}
