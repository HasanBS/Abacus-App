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

  static const _dbName = "database2.db"; //? samedb name or diffrent for every fuction ??

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

    database = await openDatabase(path, version: 1, onConfigure: _onConfigure,
        onCreate: (Database db, int version) async {
      await db.execute(countdownTable);
    });
  }

  Future _onConfigure(Database db) async {
    //? if different db is need than delete
    await db.execute('PRAGMA foreign_keys = ON');
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
  Future<bool> insertItem(CountdownModel model) async {
    final countdownMaps = await database.insert(_countdownTableName, model.toJson());

    // ignore: unnecessary_null_comparison
    return countdownMaps != null;
  }

  @override
  Future<bool> removeItem(int id) async {
    final countdownMaps =
        await database.delete(_countdownTableName, where: '$_columnId = ?', whereArgs: [id]);
    // ignore: unnecessary_null_comparison
    return countdownMaps != null;
  }

  @override
  Future<bool> updateItem(int id, CountdownModel model) async {
    final countdownMaps = await database
        .update(_countdownTableName, model.toJson(), where: '$_columnId = ?', whereArgs: [id]);
    // ignore: unnecessary_null_comparison
    return countdownMaps != null;
  }

  @override
  Future<void> close() async {
    // if (database == null) database;
    await database.close();
  }
}
