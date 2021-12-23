import 'dart:async';
import 'package:bloc/bloc.dart';
import '../model/counter_model.dart';
import '../provider/counter_database_provider.dart';
part 'counter_state.dart';

class CounterCubit extends Cubit<CounterState> {
  CounterDatabaseProvider provider;

  CounterCubit(
    this.provider,
  ) : super(CounterLoadInProgress());

  Future<void> insertCounter(CounterModel model) async {
    if (state is CounterListLoadSuccess) {
      await provider.insertItem(model);
      getCounterList();
    }
  }

  Future<void> getCounter(int id) async {
    try {
      final counter = await provider.getItem(id);
      emit(CounterLoadSuccess(counter!));
    } on Exception catch (e) {
      emit(CounterLoadFailure(e));
    }
  }

  Future<void> getCounterList() async {
    try {
      final counterList = await provider.getList();
      emit(CounterListLoadSuccess(counterList));
    } on Exception catch (e) {
      emit(CounterLoadFailure(e));
    }
  }

  Future<void> updateCounter(CounterModel model) async {
    await provider.updateItem(model.id!, model);
    getCounterList();
  }

  Future<void> removeCounter(int id) async {
    if (state is CounterListLoadSuccess) {
      final updatedCounters = (state as CounterListLoadSuccess)
          .counterList
          .where((counter) => counter.id != id)
          .toList();
      emit(CounterListLoadSuccess(updatedCounters));
      await provider.removeItem(id);
    }
  }
}
