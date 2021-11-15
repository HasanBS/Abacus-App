import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';

import '../../../../core/extension/context_extension.dart';

class DateBottomPicker extends BottomPicker {
  DateBottomPicker.date({
    required BuildContext context,
    required String title,
    required DateTime initialDateTime,
    Function(dynamic)? onChange,
    Function(dynamic)? onSubmit,
  }) : super.date(
          title: title,
          onChange: onChange,
          onSubmit: onSubmit,
          initialDateTime: initialDateTime,
          textStyle: context.textTheme.headline6!, //headline 6
          backgroundColor: context.colorScheme.primary,
          buttonColor: context.colorScheme.secondary,
          iconColor: context.colorScheme.primary,
          titleStyle: context.textTheme.headline6!,
          dismissable: true,
        );
}
