import '../text_theme.dart';
import 'color_scheme_dark.dart';

abstract class IDarkTheme {
  TextTheme? textTheme = TextTheme.instance;
  ColorSchemeDark? colorSchemeDark = ColorSchemeDark.instance;
}
