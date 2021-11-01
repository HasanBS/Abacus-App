import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memo_notes/view/home/countdown/cubit/countdown_cubit.dart';
import 'package:memo_notes/view/home/countdown/model/countdown_model.dart';
import 'package:memo_notes/view/home/countdown/provider/countdown_database_provider.dart';

class MockCountdownCubit extends MockCubit<CountdownState> implements CountdownCubit {}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  CountdownDatabaseProvider.instance.initDB();

  group('Countdown Cubit Get Operations Test', () {
    blocTest(
      'get Countdown List',
      build: () => CountdownCubit()..getCountdownList(),
      expect: () => [isA<CountdownListLoadSuccess>()],
    );

    blocTest(
      'get choosen Countdown',
      build: () => CountdownCubit()..getCountdown(1),
      expect: () => [isA<CountdownLoadSuccess>()],
    );
  });

  group('Countdown Cubit Insert,Remove and Update Operations Test', () {
    final CountdownModel countdownModel = CountdownModel(title: "test", goalDate: "2023");
    blocTest(
      'insert CountdownModel',
      build: () => CountdownCubit()..insertCountdown(countdownModel),
      expect: () => [isA<CountdownListLoadSuccess>()],
    );

    // blocTest(
    //   'update CountdownModel ',
    //   build: () => CountdownCubit()..updateCountdown(id, model),
    //   expect: () => [isA<CountdownListLoadSuccess>()],
    // );

    blocTest(
      'remove CountdownModel ',
      build: () => CountdownCubit()..removeCountdown(1),
      expect: () => [isA<CountdownListLoadSuccess>()],
    );
  });
}
