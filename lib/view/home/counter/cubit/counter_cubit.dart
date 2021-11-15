import 'dart:async';

import 'package:bloc/bloc.dart';

import '../model/counter_action_model.dart';
import '../model/counter_model.dart';
import '../provider/counter_database_provider.dart';

part 'counter_state.dart';

class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(CounterLoadInProgress());

  List<CounterActionModel?> actionList = [];

  Future<void> insertCounter(CounterModel model) async {
    if (state is CounterListLoadSuccess) {
      await CounterDatabaseProvider.instance.insertItem(model);
      getCounterList();
    }
  }

  Future<void> getCounter(int id) async {
    try {
      final counter = await CounterDatabaseProvider.instance.getItem(id);
      emit(CounterLoadSuccess(counter!));
    } on Exception catch (e) {
      emit(CounterLoadFailure(e));
    }
  }

  Future<void> getCounterList() async {
    try {
      final counterList = await CounterDatabaseProvider.instance.getList();
      emit(CounterListLoadSuccess(counterList));
    } on Exception catch (e) {
      emit(CounterLoadFailure(e));
    }
  }

  Future<void> updateCounter(int id, CounterModel model) async {
    await CounterDatabaseProvider.instance.updateItem(id, model); //?Stady
    getCounterList();
  }

  Future<void> removeCounter(int id) async {
    if (state is CounterListLoadSuccess) {
      final updatedCounters = (state as CounterListLoadSuccess)
          .counterList
          .where((counter) => counter!.id != id)
          .toList();
      emit(CounterListLoadSuccess(updatedCounters));
      await CounterDatabaseProvider.instance.removeItem(id); //?is Stady
    }
  }

  Future<void> insertAction(CounterActionModel model) async {
    await CounterDatabaseProvider.instance.insertActionItem(model);
  }

  Future<void> insertActionUpdateModel(
      CounterActionModel actionModel, CounterModel counterModel) async {
    await insertAction(actionModel);
    updateCounter(counterModel.id!, counterModel);
  }

  Future<void> getActionList() async {
    try {
      final actionList = await CounterDatabaseProvider.instance.getActionList();
      emit(CounterActionListLoadSuccess(actionList));
    } on Exception catch (e) {
      emit(CounterLoadFailure(e));
    }
  }
}
