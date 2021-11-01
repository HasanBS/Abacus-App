import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/init/database/database_manager.dart';
import '../model/counter_action_model.dart';
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

  static const _actionTableName = "counter_action";

  static const _columnCounterId = "counterId";
  static const _columnIsPositive = "isPositive"; //0 means false (-) 1 means true (+)
  static const _columnActionTotal = "actionTotal";
  static const _columnActionAmount = "actionAmount";
  static const _columnActionDate = "actionDate";

  static const counterTable = """
   CREATE TABLE $_counterTableName( 
        $_columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $_columnTitle Text NOT NULL, 
        $_columnDescription TEXT,
        $_columnTotal double NOT NULL,
        $_columnRatio double NOT NULL, 
        $_columnDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
      """;

  static const counterActionTable = """
 CREATE TABLE $_actionTableName(
        $_columnId INTEGER PRIMARY KEY AUTOINCREMENT,
         $_columnCounterId INTEGER,
         $_columnIsPositive BOOLEAN NOT NULL CHECK ($_columnIsPositive IN (0, 1)),
         $_columnActionTotal double NOT NULL,
        $_columnActionAmount double NOT NULL,
        $_columnActionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
         FOREIGN KEY($_columnCounterId) REFERENCES $_counterTableName(id) ON DELETE CASCADE
        );
      """;

  @override
  Future<void> initDB() async {
    //print("initDB executed");

    // Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // String path = join(documentsDirectory.path, _dbName);

    final path = join(await getDatabasesPath(), _dbName);
    //await deleteDatabase(path);
    database = await openDatabase(path, version: 1, onConfigure: _onConfigure,
        onCreate: (Database db, int version) async {
      await db.execute(counterTable);
      await db.execute(counterActionTable);
    });
    //print("Finitooooo  " + database.isOpen.toString());
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  @override
  Future<List<CounterModel?>> getList() async {
    // print("Listtttt  " + database.isOpen.toString());
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
  Future<bool> insertItem(CounterModel model) async {
    //print("Insertttt  " + database.isOpen.toString());
    final counterMaps = await database.insert(_counterTableName, model.toJson());

    // ignore: unnecessary_null_comparison
    return counterMaps != null;
  }

  Future<bool> insertActionItem(CounterActionModel model) async {
    final counterMaps = await database.insert(_actionTableName, model.toJson());

    // ignore: unnecessary_null_comparison
    return counterMaps != null;
  }

  Future<List<CounterActionModel?>> getActionList() async {
    final List<Map<String, dynamic>> counterMaps = await database.query(_actionTableName);
    return counterMaps.map((e) => CounterActionModel.fromJson(e)).toList();
  }

  Future<bool> removeActionItem(int id) async {
    final counterMap =
        await database.delete(_actionTableName, where: '$_columnId = ?', whereArgs: [id]);
    // ignore: unnecessary_null_comparison
    return counterMap != null;
  }

  @override
  Future<bool> removeItem(int id) async {
    final counterMap =
        await database.delete(_counterTableName, where: '$_columnId = ?', whereArgs: [id]);
    // ignore: unnecessary_null_comparison
    return counterMap != null;
  }

  @override
  Future<bool> updateItem(int id, CounterModel model) async {
    final counterMap = await database
        .update(_counterTableName, model.toJson(), where: '$_columnId = ?', whereArgs: [id]);
    // ignore: unnecessary_null_comparison
    return counterMap != null;
  }

  @override
  Future<void> close() async {
    // if (database == null) database;
    await database.close();
  }

  // String _dbName = "Database.db";
  // String _counterTableName = "counter";
  // String _actionTableName = "counter_action";
  // int _version = 2;
  // //late Database database;

  // String _columnId = "id";
  // String _columnTitle = "title";
  // String _columnDescription = "description";
  // String _columnTotal = "counterTotal";
  // String _columnRatio = "counterRatio";
  // String _columnIcon = "counterIcon";
  // String _columnDate = "createDate";

  // String _columnCounterId = "counterId";
  // String _columnIsPositive = "isPositive"; //0 means false (-) 1 means true (+)
  // String _columnActionTotal = "actionTotal";
  // String _columnActionAmount = "actionAmount";
  // String _columnActionDate = "actionDate";

  // Future<void> open() async {
  //   Directory documentsDirectory = await getApplicationDocumentsDirectory();
  //   String path = join(documentsDirectory.path, _dbName);
  //   database = await openDatabase(path,
  //       version: _version, onConfigure: _onConfigure, onCreate: (db, version) {
  //     createTable(db);
  //   });
  // }

  // Future _onConfigure(Database db) async {
  //   await db.execute('PRAGMA foreign_keys = ON');
  // }

  // @override
  // Future<void> createTable(Database db) async {
  //   await db.execute("""
  //     CREATE TABLE $_counterTableName(
  //       $_columnId INTEGER PRIMARY KEY AUTOINCREMENT,
  //       $_columnTitle Text NOT NULL,
  //       $_columnDescription TEXT,
  //       $_columnTotal double NOT NULL,
  //       $_columnRatio double NOT NULL,
  //       $_columnIcon text,
  //       $_columnDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
  //   """);

  //   await db.execute('''
  //     CREATE TABLE $_actionTableName(
  //       $_columnId INTEGER PRIMARY KEY AUTOINCREMENT,
  //       $_columnCounterId INTEGER,
  //       $_columnIsPositive BOOLEAN NOT NULL CHECK ($_columnIsPositive IN (0, 1)),
  //       $_columnActionTotal double NOT NULL,
  //       $_columnActionAmount double NOT NULL,
  //       $_columnActionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  //       FOREIGN KEY($_columnCounterId) REFERENCES $_counterTableName(id) ON DELETE CASCADE
  //       );
  //   ''');
  // }

}
