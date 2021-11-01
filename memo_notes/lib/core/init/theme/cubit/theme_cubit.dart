import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../app_theme.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(themeMode: ThemeMode.light)) {
    updateAppTheme();
  }

  void updateAppTheme() {
    final Brightness currentBrightness = AppTheme.currentSystemBrightness;
    currentBrightness == Brightness.light ? _setTheme(ThemeMode.light) : _setTheme(ThemeMode.dark);
  }

  void _setTheme(ThemeMode themeMode) {
    AppTheme.setStatusBarAndNavigationBarColors(themeMode);
    emit(ThemeState(themeMode: themeMode));
  }
}
