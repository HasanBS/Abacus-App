import 'package:flutter/material.dart';

import '../../home/countdown/provider/countdown_database_provider.dart';
import '../../home/counter/provider/counter_database_provider.dart';
import '../../home/todo/provider/todo_database_provider.dart';

class SplashService {
  static SplashService? _instance;

  static SplashService get instance {
    return _instance ??= SplashService._init();
  }

  SplashService._init() {
    _serviceInit();
  }

  Future<void> _serviceInit() async {
    WidgetsFlutterBinding.ensureInitialized();
    await CounterDatabaseProvider.instance.initDB();
    await CountdownDatabaseProvider.instance.initDB();
    await TodoDatabaseProvider.instance.initDB();
  }
}
