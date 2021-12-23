import 'package:flutter/material.dart';

import '../../constants/app/app_constants.dart';
import 'dark/dark_theme_interface.dart';
import 'iapp_theme.dart';

class AppThemeDark extends IAppTheme with IDarkTheme {
  static AppThemeDark? _instance;
  static AppThemeDark get instance {
    return _instance ??= AppThemeDark._init();
  }

  AppThemeDark._init();

  @override
  ThemeData get theme => ThemeData(
        elevatedButtonTheme: elevatedButtonTheme,
        textSelectionTheme: textSelectionTheme,
        snackBarTheme: snackBarTheme,
        indicatorColor: _appColorScheme.secondary,
        fontFamily: AppConstants.FONT_FAMILY,
        colorScheme: _appColorScheme,
        textTheme: textThemes,
        appBarTheme: appBarTheme,
        inputDecorationTheme: inputDecorationTheme,
        scaffoldBackgroundColor: _appColorScheme.primary,
        floatingActionButtonTheme: floatingActionButtonTheme,
        buttonTheme: buttonTheme,
        tabBarTheme: tabBarTheme,
      );

  ElevatedButtonThemeData get elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            side: BorderSide(color: _appColorScheme.secondary),
          ),
        ),
      ),
    );
  }

  TextSelectionThemeData get textSelectionTheme {
    return TextSelectionThemeData(
        selectionHandleColor: _appColorScheme.secondary.withOpacity(0.9),
        cursorColor: _appColorScheme.secondary,
        selectionColor: _appColorScheme.secondary.withOpacity(0.2));
  }

  SnackBarThemeData get snackBarTheme {
    return SnackBarThemeData(
      contentTextStyle: textTheme!.bodyText1.copyWith(color: _appColorScheme.primary),
      backgroundColor: _appColorScheme.secondary,
    );
  }

  ColorScheme get _appColorScheme {
    return const ColorScheme.dark().copyWith(
      primary: colorSchemeDark!.darkColor,
      secondary: colorSchemeDark!.lightColor,
      onPrimary: colorSchemeDark!.lightColor,
      brightness: Brightness.dark,
    );
  }

  TextTheme get textThemes {
    return ThemeData.dark()
        .textTheme
        .copyWith(
          headline1: textTheme!.headline1,
          headline2: textTheme!.headline2,
          headline3: textTheme!.headline3,
          headline4: textTheme!.headline4,
          headline5: textTheme!.headline5,
          headline6: textTheme!.headline6,
          bodyText1: textTheme!.bodyText1,
          bodyText2: textTheme!.bodyText2,
          subtitle1: textTheme!.headline6,
          subtitle2: textTheme!.subtitle2,
          button: textTheme!.headline6,
        )
        .apply(
          decorationColor: _appColorScheme.secondary,
          bodyColor: _appColorScheme.secondary,
          displayColor: _appColorScheme.secondary,
        );
  }

  AppBarTheme get appBarTheme {
    return ThemeData.dark().appBarTheme.copyWith(
          brightness: Brightness.dark,
          color: _appColorScheme.primary,
          elevation: 0,
        );
  }

  InputDecorationTheme get inputDecorationTheme {
    return InputDecorationTheme(
      alignLabelWithHint: true,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 0.5, color: _appColorScheme.secondary),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: _appColorScheme.secondary,
        ),
      ),
      labelStyle: textThemes.headline6!.copyWith(color: _appColorScheme.secondary),
      fillColor: _appColorScheme.primary,
    );
  }

  FloatingActionButtonThemeData get floatingActionButtonTheme {
    return ThemeData.dark().floatingActionButtonTheme.copyWith(
        backgroundColor: _appColorScheme.primary, foregroundColor: _appColorScheme.background);
  }

  ButtonThemeData get buttonTheme {
    return ThemeData.dark().buttonTheme.copyWith(
          colorScheme: const ColorScheme.dark(
            onError: Color(0xffFF2D55),
          ),
        );
  }

  TabBarTheme get tabBarTheme {
    return TabBarTheme(
      labelColor: _appColorScheme.secondary,
      labelStyle: textTheme!.headline5,
      unselectedLabelStyle: textTheme!.headline6,
      unselectedLabelColor: _appColorScheme.secondary.withOpacity(0.2),
    );
  }
}
