import 'package:easy_localization/easy_localization.dart';

extension StringLocalization on String {
  String get locale => this.tr();
}

extension IntegerExtention on int {
  String get timeString => toString().padLeft(2, '0');
}
