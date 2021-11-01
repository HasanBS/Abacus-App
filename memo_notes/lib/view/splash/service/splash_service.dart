import 'package:flutter/material.dart';

import '../../home/countdown/provider/countdown_database_provider.dart';
import '../../home/counter/provider/counter_database_provider.dart';
import '../../home/todo/provider/todo_database_provider.dart';

class SplashService {
  static SplashService? _instance;

  static SplashService get instance {
    if (_instance != null) return _instance!;
    _instance = SplashService._init();
    return _instance!;
  }

  SplashService._init();

  Future<void> serviceInit() async {
    WidgetsFlutterBinding.ensureInitialized();
    await CounterDatabaseProvider.instance.initDB();
    await CountdownDatabaseProvider.instance.initDB();
    await TodoDatabaseProvider.instance.initDB();
  }
}
