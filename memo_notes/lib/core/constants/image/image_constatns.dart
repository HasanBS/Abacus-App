import 'package:flutter/cupertino.dart';

class ImageConstants {
  static ImageConstants? _instace;

  static ImageConstants get instance => _instace ??= ImageConstants._init();

  ImageConstants._init();

  String get onboardAdd => toSvg('onboard_add');
  String get onboardDelete => toSvg('onboard_delete');
  String get onboardFinish => toSvg('onboard_finish');
  String get onboardSave => toSvg('onboard_save');

  String get iconFadeLightLoti => toLotti('icon_fade_light');
  String get iconMotionLightLoti => toLotti('icon_motion_light');
  String get iconMotionDarkLoti => toLotti('icon_motion_dark');

//icon_motion_dark
  String get trashLightLoti => toLotti('moving_trash_light');
  String get trashDarkLoti => toLotti('moving_trash_dark');

  String get shieldLightLoti => toLotti('shield_light');
  String get shieldDarkLoti => toLotti('shield_dark');

  String get trashLight30Loti => toLotti('moving_trash_light30');
  String get trashDark30Loti => toLotti('moving_trash_dark30');

  String toSvg(String name) => 'assets/images/svg/$name.svg';
  String toPng(String name) => 'assets/images/$name.png';
  String toLotti(String name) => 'assets/images/lottie/$name.json';

  IconData get plusIcon => const IconData(0xe800, fontFamily: 'MyIcon');
  IconData get minusIcon => const IconData(0xe801, fontFamily: 'MyIcon');
  IconData get rightChevron => const IconData(0xe802, fontFamily: 'MyIcon');
  IconData get leftChevron => const IconData(0xe804, fontFamily: 'MyIcon');
  IconData get backArrow => const IconData(0xe803, fontFamily: 'MyIcon');
}
