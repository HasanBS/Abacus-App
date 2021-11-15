import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'iapp_theme.dart';

class AppTheme extends IAppTheme {
  static AppTheme? _instance;

  static AppTheme? get instance {
    return _instance ??= AppTheme._init();
  }

  AppTheme._init();

  static Brightness get currentSystemBrightness =>
      SchedulerBinding.instance!.window.platformBrightness; //!

  static dynamic setStatusBarAndNavigationBarColors(ThemeMode themeMode) {
    const Color darkColor = Color(0xff313541);
    const Color lightColor = Color(0xffE8E8E8);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: themeMode == ThemeMode.light ? lightColor : darkColor,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: themeMode == ThemeMode.light ? Brightness.light : Brightness.dark,
      systemNavigationBarDividerColor: themeMode == ThemeMode.light ? lightColor : darkColor,
      systemNavigationBarIconBrightness:
          themeMode == ThemeMode.light ? Brightness.dark : Brightness.light,
    ));
  }
}
