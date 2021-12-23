import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/init/database/database_manager.dart';
import '../model/counter_model.dart';

class CounterDatabaseProvider implements DatabaseManager<CounterModel> {
  static CounterDatabaseProvider? _instance;

  static CounterDatabaseProvider get instance {
    if (_instance != null) return _instance!;
    _instance = CounterDatabaseProvider._init();
    return _instance!;
  }

  @override
  late Database database;

  CounterDatabaseProvider._init();

  static const _dbName = "database1.db";

  static const _counterTableName = "counter";

  static const _columnId = "id";
  static const _columnTitle = "title";
  static const _columnDescription = "description";
  static const _columnTotal = "counterTotal";
  static const _columnRatio = "counterRatio";
  static const _columnDate = "createDate";

  static const counterTable = """
   CREATE TABLE $_counterTableName( 
        $_columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $_columnTitle Text NOT NULL, 
        $_columnDescription TEXT,
        $_columnTotal double NOT NULL,
        $_columnRatio double NOT NULL, 
        $_columnDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
      """;

  @override
  Future<void> initDB() async {
    final path = join(await getDatabasesPath(), _dbName);
    database = await openDatabase(path, version: 1, onConfigure: _onConfigure,
        onCreate: (Database db, int version) async {
      await db.execute(counterTable);
    });
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  @override
  Future<List<CounterModel>> getList() async {
    final List<Map<String, dynamic>> counterMaps = await database.query(_counterTableName);
    return counterMaps.map((e) => CounterModel.fromJson(e)).toList();
  }

  @override
  Future<CounterModel?> getItem(int id) async {
    final counterMaps =
        await database.query(_counterTableName, where: '$_columnId = ?', whereArgs: [id]);
    if (counterMaps.isNotEmpty) {
      return CounterModel.fromJson(counterMaps.first);
    } else {
      return null;
    }
  }

  @override
  Future<void> insertItem(CounterModel model) async {
    await database.insert(_counterTableName, model.toJson());
  }

  @override
  Future<void> removeItem(int id) async {
    await database.delete(_counterTableName, where: '$_columnId = ?', whereArgs: [id]);
  }

  @override
  Future<void> updateItem(int id, CounterModel model) async {
    await database
        .update(_counterTableName, model.toJson(), where: '$_columnId = ?', whereArgs: [id]);
  }

  @override
  Future<void> close() async {
    await database.close();
  }
}
