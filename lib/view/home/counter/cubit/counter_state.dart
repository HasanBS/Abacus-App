part of 'counter_cubit.dart';

abstract class CounterState {
  const CounterState();
}

class CounterLoadInProgress extends CounterState {}

class CounterListLoadSuccess extends CounterState {
  final List<CounterModel> counterList;
  const CounterListLoadSuccess(this.counterList);
}

class CounterLoadSuccess extends CounterState {
  final CounterModel counter;
  const CounterLoadSuccess(this.counter);
}

class CounterLoadFailure extends CounterState {
  final Object e;
  const CounterLoadFailure(this.e);
}
