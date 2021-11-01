import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/app/app_constants.dart';
import 'iapp_theme.dart';
import 'light/light_theme_interface.dart';

class AppThemeLight extends IAppTheme with ILightTheme {
  static AppThemeLight? _instance;
  static AppThemeLight get instance {
    return _instance ??= AppThemeLight._init();
  }

  AppThemeLight._init();

  @override
  ThemeData get theme => ThemeData(
        //primarySwatch: MaterialColor(_appColorScheme.secondaryMap<int, Color> swatch),
        primaryTextTheme: textThemes,
        elevatedButtonTheme: elevatedButtonTheme,
        textSelectionTheme: textSelectionTheme, //Done
        snackBarTheme: snackBarTheme, //Done
        indicatorColor: _appColorScheme.secondary, //XXXXXX
        fontFamily: AppConstants.FONT_FAMILY,
        colorScheme: _appColorScheme, //XXXXXX
        textTheme: textThemes, //XXXXXX
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
      //XXXXXX
      contentTextStyle: textTheme!.bodyText1.copyWith(color: _appColorScheme.primary),
      backgroundColor: _appColorScheme.secondary,
    );
  }

  ColorScheme get _appColorScheme {
    return const ColorScheme.light().copyWith(
      primary: colorSchemeLight!.lightColor,
      secondary: colorSchemeLight!.darkColor,
      onPrimary: colorSchemeLight!.darkColor,
      brightness: Brightness.light,
    );
  }

  TextTheme get textThemes {
    return ThemeData.light()
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
    return ThemeData.light().appBarTheme.copyWith(
          //XXXXXX
          brightness: Brightness.light,
          color: _appColorScheme.primary,
          //foregroundColor: _appColorScheme.secondary,
          elevation: 0,

          // iconTheme: IconThemeData(
          //   color: _appColorScheme.secondary,
          //   size: 21,
          // ),
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
    return ThemeData.light().floatingActionButtonTheme.copyWith(
        backgroundColor: _appColorScheme.primary, foregroundColor: _appColorScheme.background);
  }

  ButtonThemeData get buttonTheme {
    return ThemeData.light().buttonTheme.copyWith(
          colorScheme: const ColorScheme.light(
            //?
            onError: Color(0xffFF2D55),
          ),
        );
  }

  TabBarTheme get tabBarTheme {
    return TabBarTheme(
      labelColor: _appColorScheme.secondary, //Choosen Label Color
      labelStyle: textTheme!.headline5,
      unselectedLabelStyle: textTheme!.headline6,
      unselectedLabelColor: _appColorScheme.secondary.withOpacity(0.2),
      // unselectedLabelStyle: textTheme.headline4.copyWith(color: colorSchemeLight.red),
    );
  }
}
