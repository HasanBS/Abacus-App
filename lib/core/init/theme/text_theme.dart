import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextTheme {
  static TextTheme? _instance;

  static TextTheme? get instance {
    return _instance ??= TextTheme._init();
  }

  TextTheme._init();

  final TextStyle headline1 =
      TextStyle(fontWeight: FontWeight.w200, fontStyle: FontStyle.normal, fontSize: 83.3.sp);

  final TextStyle headline2 =
      TextStyle(fontWeight: FontWeight.w200, fontStyle: FontStyle.normal, fontSize: 60.sp);

  final TextStyle headline3 =
      TextStyle(fontWeight: FontWeight.w200, fontStyle: FontStyle.normal, fontSize: 40.sp);

  final TextStyle headline4 =
      TextStyle(fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 33.sp);

  final TextStyle headline5 =
      TextStyle(fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 21.3.sp);

  final TextStyle headline6 =
      TextStyle(fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 20.sp);

  final TextStyle bodyText1 =
      TextStyle(fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 13.3.sp);

  final TextStyle bodyText2 = TextStyle(
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 13.3.sp);

  final TextStyle subtitle2 =
      TextStyle(fontWeight: FontWeight.w300, fontStyle: FontStyle.normal, fontSize: 24.sp);
}
