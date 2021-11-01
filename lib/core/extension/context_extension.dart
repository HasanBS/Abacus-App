import 'dart:math';

import 'package:flutter/material.dart';

// import 'widget/sized-box/space_sized_height_box.dart';
// import 'widget/sized-box/space_sized_width_box.dart';

extension ContextExtension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;
  TextTheme get primaryTextTheme => Theme.of(this).primaryTextTheme;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  ThemeData get appTheme => Theme.of(this);
  bool get isDarkTheme => MediaQuery.of(this).platformBrightness == Brightness.dark;
  MaterialColor get randomColor => Colors.primaries[Random().nextInt(17)];

  bool get isKeyBoardOpen => MediaQuery.of(this).viewInsets.bottom > 0;
  Brightness get appBrightness => MediaQuery.of(this).platformBrightness;
}

extension DoubleNumberExtension on BuildContext {
  String doubleToString(double val) => val % 1 == 0 ? (val.round()).toString() : val.toString();
}

extension MediaQueryExtension on BuildContext {
  double get height => mediaQuery.size.height;
  double get width => mediaQuery.size.width;

  double get lowValueH => height * 0.01;
  double get normalValueH => height * 0.02;
  double get mediumValueH => height * 0.04;
  double get highValueH => height * 0.1;

  double get lowValueW => width * 0.01;
  double get normalValueW => width * 0.02;
  double get mediumValueW => width * 0.04;
  double get highValueW => width * 0.1;

  double dynamicWidth(double val) => width * val;
  double dynamicHeight(double val) => height * val;
}

extension DurationExtension on BuildContext {
  Duration get durationLow => const Duration(milliseconds: 500);
  Duration get durationNormal => const Duration(seconds: 1);
  Duration get durationSlow => const Duration(seconds: 2);
}

extension PaddingExtension on BuildContext {
  EdgeInsets get paddingLow => EdgeInsets.all(lowValueH);
  EdgeInsets get paddingNormal => EdgeInsets.all(normalValueH);
  EdgeInsets get paddingMedium => EdgeInsets.all(mediumValueH);
  EdgeInsets get paddingHigh => EdgeInsets.all(highValueH);

  EdgeInsets get horizontalPaddingLow => EdgeInsets.symmetric(horizontal: lowValueW);
  EdgeInsets get horizontalPaddingNormal => EdgeInsets.symmetric(horizontal: normalValueW);
  EdgeInsets get horizontalPaddingMedium => EdgeInsets.symmetric(horizontal: mediumValueW);
  EdgeInsets get horizontalPaddingHigh => EdgeInsets.symmetric(horizontal: highValueW);

  EdgeInsets get verticalPaddingLow => EdgeInsets.symmetric(vertical: lowValueH);

  EdgeInsets get verticalPaddingNormal => EdgeInsets.symmetric(vertical: normalValueH);
  EdgeInsets get verticalPaddingMedium => EdgeInsets.symmetric(vertical: mediumValueH);
  EdgeInsets get verticalPaddingHigh => EdgeInsets.symmetric(vertical: highValueH);
}

extension SizedBoxExtension on BuildContext {
  Widget spaceSizedWidthBox(double value) => SizedBox(width: width * value);
  Widget spaceSizedHeightBox(double value) => SizedBox(height: height * value);

  Widget get emptySizedWidthBoxLow => spaceSizedWidthBox(0.03);
  Widget get emptySizedWidthBoxLow3x => spaceSizedWidthBox(0.03);
  Widget get emptySizedWidthBoxNormal => spaceSizedWidthBox(0.53);
  Widget get emptySizedWidthBoxHigh => spaceSizedWidthBox(0.1);

  Widget get emptySizedHeightBoxLow => spaceSizedHeightBox(0.01);
  Widget get emptySizedHeightBoxLow3x => spaceSizedHeightBox(0.03);
  Widget get emptySizedHeightBoxNormal => spaceSizedHeightBox(0.05);
  Widget get emptySizedHeightBoxHigh => spaceSizedHeightBox(0.1);
}

extension RadiusExtension on BuildContext {
  Radius get lowRadius => Radius.circular(width * 0.02);
  Radius get normalRadius => Radius.circular(width * 0.05);
  Radius get highadius => Radius.circular(width * 0.1);
}

extension FontSize on BuildContext {
  double calculateAutoscaleFontSize(
      String text, TextStyle style, double startFontSize, double maxWidth) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    var currentFontSize = startFontSize;

    for (var i = 0; i < 100; i++) {
      // limit max iterations to 100
      final nextFontSize = currentFontSize + 1;
      final nextTextStyle = style.copyWith(fontSize: nextFontSize);
      textPainter.text = TextSpan(text: text, style: nextTextStyle);
      textPainter.layout();
      if (textPainter.width >= maxWidth) {
        break;
      } else {
        currentFontSize = nextFontSize;
        // continue iteration
      }
    }

    return currentFontSize;
  }
}

extension BorderExtension on BuildContext {
  BorderRadius get normalBorderRadius => BorderRadius.all(Radius.circular(width * 0.05));
  BorderRadius get lowBorderRadius => BorderRadius.all(Radius.circular(width * 0.02));
  BorderRadius get highBorderRadius => BorderRadius.all(Radius.circular(width * 0.1));

  BorderRadius get highTopBorderRadius => BorderRadius.vertical(top: Radius.circular(width * 0.1));

  RoundedRectangleBorder get roundedRectangleBorderLow =>
      RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(lowValueH)));

  RoundedRectangleBorder get roundedRectangleAllBorderNormal =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(normalValueH));

  RoundedRectangleBorder get roundedRectangleBorderNormal => RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(normalValueH)));

  RoundedRectangleBorder get roundedRectangleBorderMedium => RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(mediumValueH)));

  RoundedRectangleBorder get roundedRectangleBorderHigh =>
      RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(highValueH)));
}

extension NavigationExtension on BuildContext {
  NavigatorState get navigation => Navigator.of(this);

  Future<void> pop() async {
    await navigation.maybePop();
  }

  Future<T?> navigateName<T>(String path, {Object? data}) async {
    return navigation.pushNamed<T>(path, arguments: data);
  }

  Future<T?> navigateToReset<T>(String path, {Object? data}) async {
    return navigation.pushNamedAndRemoveUntil(path, (route) => false, arguments: data);
  }
}
