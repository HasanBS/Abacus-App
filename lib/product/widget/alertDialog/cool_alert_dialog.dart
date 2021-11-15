import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';

import '../../../../core/extension/context_extension.dart';

class CoolAlertDialog extends CoolAlert {
  CoolAlertDialog({
    required BuildContext context,
    String? title,
    required String confirmBtnText,
    required String cancelBtnText,
    String? lottieAssetLight,
    String? lottieAssetDark,
    Function()? onConfirmBtnTap,
    Function()? onCancelBtnTap,
  }) : super() {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.confirm,
      title: title,
      lottieAsset: context.isDarkTheme ? lottieAssetDark : lottieAssetLight,
      onConfirmBtnTap: onConfirmBtnTap,
      onCancelBtnTap: onCancelBtnTap,
      confirmBtnText: confirmBtnText,
      cancelBtnText: cancelBtnText,
      cancelBtnTextStyle: context.textTheme.bodyText1,
      confirmBtnTextStyle: context.textTheme.bodyText1,
      confirmBtnColor: context.colorScheme.primary,
      borderRadius: 0,
      backgroundColor: context.colorScheme.primary,
    );
  }
}
