import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memo_notes/view/home/counter/cubit/counter_cubit.dart';
import 'package:memo_notes/view/home/counter/model/counter_model.dart';
import 'package:memo_notes/view/home/counter/provider/counter_database_provider.dart';

class MockCounterCubit extends MockCubit<CounterState> implements CounterCubit {}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  CounterDatabaseProvider.instance.initDB();

  group('Counter Cubit Get Operations Test', () {
    blocTest(
      'get choosen CounterModel',
      build: () => CounterCubit(CounterDatabaseProvider.instance)..getCounter(1),
      expect: () => [isA<CounterLoadSuccess>()],
    );

    blocTest(
      'get CounterModel List',
      build: () => CounterCubit(CounterDatabaseProvider.instance)..getCounterList(),
      expect: () => [isA<CounterListLoadSuccess>()],
    );
  });

  group('Counter Cubit Insert,Remove Operations Test', () {
    final counterModel = CounterModel(title: "test", counterTotal: 0, counterRatio: 2);

    blocTest(
      'insert CounterModel',
      build: () => CounterCubit(CounterDatabaseProvider.instance)..insertCounter(counterModel),
      expect: () => [isA<CounterLoadSuccess>()],
    );

    blocTest(
      'remove CounterModel ',
      build: () => CounterCubit(CounterDatabaseProvider.instance)..removeCounter(2),
      expect: () => [isA<CounterListLoadSuccess>()],
    );
  });
}
