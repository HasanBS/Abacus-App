extension DurationUnits on Duration {
  int get days => inDays;
  int get hours => inHours % Duration.hoursPerDay;
  int get minutes => inMinutes % Duration.minutesPerHour;
  int get seconds => inSeconds % Duration.secondsPerMinute;
  int get milliseconds => inMilliseconds % Duration.millisecondsPerSecond;
  int get microseconds => inMicroseconds % Duration.microsecondsPerMillisecond;
}

extension PastDurationUnits on Duration {
  int get pastDays => -inDays;
  int get pastHours => -inHours % Duration.hoursPerDay;
  int get pastMinutes => -inMinutes % Duration.minutesPerHour;
  int get pastSeconds => -inSeconds % Duration.secondsPerMinute;
  int get pastMilliseconds => -inMilliseconds % Duration.millisecondsPerSecond;
  int get pastMicroseconds => -inMicroseconds % Duration.microsecondsPerMillisecond;
}
