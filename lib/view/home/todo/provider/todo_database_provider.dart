import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/init/database/database_manager.dart';
import '../model/todo_model.dart';

class TodoDatabaseProvider implements DatabaseManager<TodoModel> {
  static TodoDatabaseProvider? _instance;

  static TodoDatabaseProvider get instance {
    if (_instance != null) return _instance!;
    _instance = TodoDatabaseProvider._init();
    return _instance!;
  }

  @override
  late Database database;

  TodoDatabaseProvider._init();

  static const _dbName = "database3.db";
  static const _todoTableName = "todo";
  static const _columnId = "id";
  static const _columnTitle = "title";
  static const _columnDescription = "description";
  static const _columnDate = "createDate";
  static const _columnIsDone = "isDone"; //0 means false (-) 1 means true (+)
  static const _columnDoneDate = "doneDate";

// DEFAULT CURRENT_TIMESTAMP
  static const _todoTable = """
 CREATE TABLE $_todoTableName(
        $_columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $_columnTitle Text NOT NULL, 
        $_columnDescription TEXT,
        $_columnIsDone BOOLEAN NOT NULL CHECK ($_columnIsDone IN (0, 1)),
        $_columnDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        $_columnDoneDate TIMESTAMP
        );
      """;
  @override
  Future<void> initDB() async {
    final path = join(await getDatabasesPath(), _dbName);
    //await deleteDatabase(path);

    database = await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute(_todoTable);
    });
  }

  @override
  Future<void> insertItem(TodoModel model) async {
    await database.insert(_todoTableName, model.toJson());
  }

  @override
  Future<TodoModel?> getItem(int id) async {
    final todoModelMaps =
        await database.query(_todoTableName, where: '$_columnId = ?', whereArgs: [id]);
    if (todoModelMaps.isNotEmpty) {
      return TodoModel.fromJson(todoModelMaps.first);
    } else {
      return null;
    }
  }

  @override
  Future<List<TodoModel?>> getList() async {
    final todoItemListMaps = await database.query(_todoTableName);
    return todoItemListMaps.map((e) => TodoModel.fromJson(e)).toList();
  }

  @override
  Future<void> updateItem(int id, TodoModel model) async {
    await database.update(_todoTableName, model.toJson(), where: '$_columnId = ?', whereArgs: [id]);
  }

  @override
  Future<void> removeItem(int id) async {
    await database.delete(_todoTableName, where: '$_columnId = ?', whereArgs: [id]);
  }

  @override
  Future<void> close() async {
    await database.close();
  }
}
