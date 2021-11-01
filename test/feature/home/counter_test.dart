import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memo_notes/view/home/counter/cubit/counter_cubit.dart';
import 'package:memo_notes/view/home/counter/model/counter_action_model.dart';
import 'package:memo_notes/view/home/counter/model/counter_model.dart';
import 'package:memo_notes/view/home/counter/provider/counter_database_provider.dart';

class MockCounterCubit extends MockCubit<CounterState> implements CounterCubit {}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  CounterDatabaseProvider.instance.initDB();

  group('Counter Cubit Get Operations Test', () {
    blocTest(
      'get CounterActionModel List',
      build: () => CounterCubit()..getActionList(),
      expect: () => [isA<CounterActionListLoadSuccess>()],
    );

    blocTest(
      'get choosen CounterModel',
      build: () => CounterCubit()..getCounter(1),
      expect: () => [isA<CounterLoadSuccess>()],
    );

    blocTest(
      'get CounterModel List',
      build: () => CounterCubit()..getCounterList(),
      expect: () => [isA<CounterListLoadSuccess>()],
    );
  });

  group('Counter Cubit Insert,Remove and Update Operations Test', () {
    final counterActionModel =
        CounterActionModel(counterId: 0, isPositive: 0, actionTotal: 0, actionAmount: 0);

    final counterModel = CounterModel(title: "test", counterTotal: 0, counterRatio: 2);
    blocTest(
      'insert CounterActionModel',
      build: () => CounterCubit()..insertAction(counterActionModel),
      expect: () => [isA<CounterActionListLoadSuccess>()],
    );

    blocTest(
      'insert CounterModel',
      build: () => CounterCubit()..insertCounter(counterModel),
      expect: () => [isA<CounterLoadSuccess>()],
    );

    // blocTest(
    //   'update CounterModel ',
    //   build: () => CounterCubit()..updateCounter(0, counterModel),
    //   expect: () => [isA<CounterListLoadSuccess>()],
    // );

    blocTest(
      'remove CounterModel ',
      build: () => CounterCubit()..removeCounter(2),
      expect: () => [isA<CounterListLoadSuccess>()],
    );
  });
}
