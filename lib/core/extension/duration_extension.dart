import 'package:easy_localization/easy_localization.dart';

import '../../view/home/countdown/model/duration_model.dart';
import '../extension/string_extension.dart';
import '../init/lang/locale_keys.g.dart';

extension DurationUnits on Duration {
  int get years => inDays ~/ 365;
  int get mounts => ((inDays - (years * 365)) ~/ 30.41) % 12;
  int get days => ((inDays - (years * 365) - (mounts * 30.41)) % (30.41)).toInt();
  int get hours => inHours % Duration.hoursPerDay;
  int get minutes => inMinutes % Duration.minutesPerHour;
  int get seconds => inSeconds % Duration.secondsPerMinute;
  int get milliseconds => inMilliseconds % Duration.millisecondsPerSecond;
  int get microseconds => inMicroseconds % Duration.microsecondsPerMillisecond;
}

extension DateTimeExtension on DateTime {
  String get stringDate =>
      '${hour.timeString}:${minute.timeString}:${second.timeString}   ${day.timeString}.${month.timeString}.$year';
}

extension DurationModelExtension on DurationModel {
  bool get filledYear => year > 0;
  bool get filledMonth => month > 0;
  bool get filledDay => day > 0;
  bool get filledHour => hour > 0;
  bool get filledMinute => minute > 0;
  bool get filledSecond => second > 0;

  List<String> get filledTwo {
    String? firstPartOfDate;
    String? secondPartOfDate;

    if (filledYear) {
      firstPartOfDate = LocaleKeys.countdown_buttonField_year.tr(args: [year.timeString]);
    }
    if (filledMonth) {
      if (firstPartOfDate == null) {
        firstPartOfDate = LocaleKeys.countdown_buttonField_month.tr(args: [month.timeString]);
      } else {
        secondPartOfDate = LocaleKeys.countdown_buttonField_month.tr(args: [month.timeString]);
      }
    }
    if (secondPartOfDate == null && filledDay) {
      if (firstPartOfDate == null) {
        firstPartOfDate = LocaleKeys.countdown_buttonField_day.tr(args: [day.timeString]);
      } else {
        secondPartOfDate = LocaleKeys.countdown_buttonField_day.tr(args: [day.timeString]);
      }
    }

    if (secondPartOfDate == null && filledHour) {
      if (firstPartOfDate == null) {
        firstPartOfDate = LocaleKeys.countdown_buttonField_hour.tr(args: [hour.timeString]);
      } else {
        secondPartOfDate = LocaleKeys.countdown_buttonField_hour.tr(args: [hour.timeString]);
      }
    }

    if (secondPartOfDate == null && filledMinute) {
      if (firstPartOfDate == null) {
        firstPartOfDate = LocaleKeys.countdown_buttonField_minute.tr(args: [minute.timeString]);
      } else {
        secondPartOfDate = LocaleKeys.countdown_buttonField_minute.tr(args: [minute.timeString]);
      }
    }
    if (secondPartOfDate == null && filledSecond) {
      secondPartOfDate = LocaleKeys.countdown_buttonField_second.tr(args: [second.timeString]);
    }
    firstPartOfDate =
        firstPartOfDate ?? LocaleKeys.countdown_buttonField_minute.tr(args: [minute.timeString]);
    secondPartOfDate =
        secondPartOfDate ?? LocaleKeys.countdown_buttonField_second.tr(args: [second.timeString]);

    return [firstPartOfDate, secondPartOfDate];
  }
}

// extension PastDurationUnits on Duration {
//   int get pastDays => -inDays;
//   int get pastHours => -inHours % Duration.hoursPerDay;
//   int get pastMinutes => -inMinutes % Duration.minutesPerHour;
//   int get pastSeconds => -inSeconds % Duration.secondsPerMinute;
//   int get pastMilliseconds => -inMilliseconds % Duration.millisecondsPerSecond;
//   int get pastMicroseconds => -inMicroseconds % Duration.microsecondsPerMillisecond;
// }