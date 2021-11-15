import 'package:flutter/material.dart';

import '../../../../core/extension/context_extension.dart';

class CustomDivider extends Divider {
  CustomDivider(BuildContext context)
      : super(
          indent: context.dynamicWidth(0.04),
          endIndent: context.dynamicWidth(0.04),
          color: context.colorScheme.secondary,
          thickness: 0.5,
        );
}
