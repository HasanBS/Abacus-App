import '../../../../../core/extension/duration_extension.dart';
import '../../model/duration_model.dart';

class CountdownCalculator {
  const CountdownCalculator() : super();

  DurationModel initCalculation({required DateTime dateTime}) => _durationCalulation(dateTime);

  Stream<DurationModel> calculator({required DateTime dateTime}) {
    return Stream.periodic(const Duration(seconds: 1), (_) => _durationCalulation(dateTime));
  }

  DurationModel _durationCalulation(DateTime fromDate) {
    // Check if toDate to be included in the calculation
    DateTime endDate;
    DateTime startDate;

    int years = 0;
    int months = 0;
    int days = 0;
    int hours = 0;
    int minutes = 0;
    int seconds = 0;
    bool isPast = false;

    if (fromDate.isBefore(DateTime.now())) {
      isPast = true;
      endDate = DateTime.now();
      startDate = fromDate;
    } else {
      isPast = false;
      endDate = fromDate;
      startDate = DateTime.now();
    }

    //Clock set
    final tempStart = DateTime(1, 1, 1, startDate.hour, startDate.minute, startDate.second);
    final tempEnd = DateTime(1, 1, 1, endDate.hour, endDate.minute, endDate.second);
    final timeDifference = tempEnd.difference(tempStart);

    if (timeDifference.isNegative) {
      days--;
      final durationSeconds = timeDifference.inSeconds + Duration.secondsPerDay;

      hours = ((durationSeconds ~/ Duration.secondsPerMinute) ~/ Duration.minutesPerHour) %
          Duration.hoursPerDay;
      minutes = (durationSeconds ~/ Duration.secondsPerMinute) % Duration.minutesPerHour;
      seconds = durationSeconds % Duration.secondsPerMinute;
    } else {
      hours = timeDifference.hours;
      minutes = timeDifference.minutes;
      seconds = timeDifference.seconds;
    }

    //date sett
    years = endDate.year - startDate.year;

    if (startDate.month > endDate.month) {
      years--;
      months = DateTime.monthsPerYear + endDate.month - startDate.month;

      if (startDate.day > endDate.day) {
        months--;
        days = _daysInMonth(startDate.year + years,
                ((startDate.month + months - 1) % DateTime.monthsPerYear) + 1) +
            endDate.day -
            startDate.day;
      } else {
        days = endDate.day - startDate.day;
      }
    } else if (endDate.month == startDate.month) {
      if (startDate.day > endDate.day) {
        years--;
        months = DateTime.monthsPerYear - 1;
        days = _daysInMonth(startDate.year + years,
                ((startDate.month + months - 1) % DateTime.monthsPerYear) + 1) +
            endDate.day -
            startDate.day;
      } else {
        days = endDate.day - startDate.day;
      }
    } else {
      months = endDate.month - startDate.month;

      if (startDate.day > endDate.day) {
        months--;
        days = _daysInMonth(startDate.year + years, startDate.month + months) +
            endDate.day -
            startDate.day;
      } else {
        days = endDate.day - startDate.day;
      }
    }

    return DurationModel(years, months, days, hours, minutes, seconds, isPast);
  }

  /// isLeapYear method
  bool _isLeapYear(int year) => (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));

  /// daysInMonth method
  int _daysInMonth(int year, int month) {
    final List<int> _daysInMonth = [
      31, // Jan
      28, // Feb, it varies from 28 to 29
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31 // Dec
    ];
    return (month == DateTime.february && _isLeapYear(year)) ? 29 : _daysInMonth[month - 1];
  }
}
