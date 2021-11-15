import 'package:easy_localization/easy_localization.dart';

extension StringLocalization on String {
  String get locale => this.tr();

  // String? get isValidEmail =>
  //     contains(RegExp(AppConstants.EMAIL_REGIEX)) ? null : 'Email does not valid';

  // bool get isValidEmails => RegExp(AppConstants.EMAIL_REGIEX).hasMatch(this);
}

extension IntegerExtention on int {
  String get timeString => toString().padLeft(2, '0');
}
