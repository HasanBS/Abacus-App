import 'package:flutter/material.dart';

class ColorSchemeDark {
  static ColorSchemeDark? _instace;

  static ColorSchemeDark? get instance {
    return _instace ??= ColorSchemeDark._init();
  }

  ColorSchemeDark._init();

  final Color darkColor = const Color(0xff313541);
  final Color lightColor = const Color(0xffE8E8E8);
}
