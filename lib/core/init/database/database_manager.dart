import 'package:sqflite/sqflite.dart';

import 'idatabase_model.dart';

abstract class DatabaseManager<T extends IDatabaseModel> {
  late Database database;
  Future<void> initDB();
  Future<T?> getItem(int id);
  Future<List<T?>> getList();
  Future<void> updateItem(int id, T model);
  Future<void> removeItem(int id);
  Future<void> insertItem(T model);
  Future<void> close();
}
