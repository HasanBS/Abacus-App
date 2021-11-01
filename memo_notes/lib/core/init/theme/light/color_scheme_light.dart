import 'package:flutter/material.dart';

class ColorSchemeLight {
  static ColorSchemeLight? _instace;

  static ColorSchemeLight? get instance {
    return _instace ??= ColorSchemeLight._init();
  }

  ColorSchemeLight._init();

  final Color darkColor = const Color(0xff313541);
  final Color lightColor = const Color(0xffE8E8E8);
}
