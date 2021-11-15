import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/init/database/database_manager.dart';
import '../model/countdown_model.dart';

class CountdownDatabaseProvider implements DatabaseManager<CountdownModel> {
  static CountdownDatabaseProvider? _instance;

  static CountdownDatabaseProvider get instance {
    if (_instance != null) return _instance!;
    _instance = CountdownDatabaseProvider._init();
    return _instance!;
  }

  @override
  late Database database;

  CountdownDatabaseProvider._init();

  static const _dbName = "database2.db";
  static const _countdownTableName = "countdown";
  static const _columnId = "id";
  static const _columnTitle = "title";
  static const _columnDescription = "description";
  static const _columnGoalDate = "goalDate";
  static const _columnDate = "createDate";

  static const countdownTable = """
   CREATE TABLE $_countdownTableName( 
        $_columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $_columnTitle Text NOT NULL, 
        $_columnDescription TEXT,
        $_columnGoalDate TIMESTAMP,
        $_columnDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
      """;

  @override
  Future<void> initDB() async {
    final path = join(await getDatabasesPath(), _dbName);
    //await deleteDatabase(path);

    database = await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute(countdownTable);
    });
  }

  @override
  Future<List<CountdownModel?>> getList() async {
    final List<Map<String, dynamic>> countdownMaps = await database.query(_countdownTableName);
    return countdownMaps.map((e) => CountdownModel.fromJson(e)).toList();
  }

  @override
  Future<CountdownModel?> getItem(int id) async {
    final countdownMaps =
        await database.query(_countdownTableName, where: '$_columnId = ?', whereArgs: [id]);
    if (countdownMaps.isNotEmpty) {
      return CountdownModel.fromJson(countdownMaps.first);
    } else {
      return null;
    }
  }

  @override
  Future<void> insertItem(CountdownModel model) async {
    await database.insert(_countdownTableName, model.toJson());
  }

  @override
  Future<void> removeItem(int id) async {
    await database.delete(_countdownTableName, where: '$_columnId = ?', whereArgs: [id]);
  }

  @override
  Future<void> updateItem(int id, CountdownModel model) async {
    await database
        .update(_countdownTableName, model.toJson(), where: '$_columnId = ?', whereArgs: [id]);
  }

  @override
  Future<void> close() async {
    await database.close();
  }
}
