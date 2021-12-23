import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../model/countdown_model.dart';
import '../provider/countdown_database_provider.dart';

part 'countdown_state.dart';

class CountdownCubit extends Cubit<CountdownState> {
  CountdownDatabaseProvider provider;
  CountdownCubit(
    this.provider,
  ) : super(CountdownLoadInProgress());

  Future<void> insertCountdown(CountdownModel model) async {
    if (state is CountdownListLoadSuccess) {
      await provider.insertItem(model);
      getCountdownList();
    }
  }

  Future<void> getCountdown(int id) async {
    try {
      final countdown = await provider.getItem(id);
      emit(CountdownLoadSuccess(countdown!));
    } on Exception catch (e) {
      emit(CountdownLoadFailure(e));
    }
  }

  Future<void> getCountdownList() async {
    try {
      final countdownList = await provider.getList();
      emit(CountdownListLoadSuccess(countdownList));
    } catch (e) {
      emit(CountdownLoadFailure(e));
    }
  }

  Future<void> updateCountdown(CountdownModel model) async {
    await provider.updateItem(model.id!, model); //?Stady
    getCountdownList();
  }

  Future<void> removeCountdown(int id) async {
    if (state is CountdownListLoadSuccess) {
      final updatedCountdowns = (state as CountdownListLoadSuccess)
          .countdownList
          .where((countdown) => countdown.id != id)
          .toList();
      emit(CountdownListLoadSuccess(updatedCountdowns));
      await provider.removeItem(id); //?is Stady
    }
  }
}
