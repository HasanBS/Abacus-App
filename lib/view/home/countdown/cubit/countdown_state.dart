part of 'countdown_cubit.dart';

@immutable
abstract class CountdownState {
  const CountdownState();
}

class CountdownLoadInProgress extends CountdownState {}

class CountdownListLoadSuccess extends CountdownState {
  final List<CountdownModel?> countdownList;
  const CountdownListLoadSuccess(this.countdownList);
}

class CountdownLoadSuccess extends CountdownState {
  final CountdownModel countdown;
  const CountdownLoadSuccess(this.countdown);
}

class CountdownLoadFailure extends CountdownState {
  final Object e;
  const CountdownLoadFailure(this.e);
}
