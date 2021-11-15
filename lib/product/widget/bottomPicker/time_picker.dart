import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';

import '../../../../core/extension/context_extension.dart';

class TimeBottomPicker extends BottomPicker {
  TimeBottomPicker.time({
    required BuildContext context,
    required String title,
    DateTime? initialDateTime,
    Function(dynamic)? onChange,
    Function(dynamic)? onSubmit,
  }) : super.time(
          title: title,
          onChange: onChange,
          onSubmit: onSubmit,
          initialDateTime: initialDateTime,
          textStyle: context.textTheme.headline6!,
          backgroundColor: context.colorScheme.primary,
          buttonColor: context.colorScheme.secondary,
          iconColor: context.colorScheme.primary,
          titleStyle: context.textTheme.headline6!,
          dismissable: true,
          use24hFormat: true,
        );
}
