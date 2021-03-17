import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _dbName = 'myDatabase.db';
  static final _dbVersion = 1;
  static final _tableName = 'myTable';
  static final _tableName2 = 'completedItems';

  static final columnId = '_id';
  static final columnName = 'name';
  static final columnName2 = 'dateTime';
  static final columnName3 = 'completedOn';
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initiateDatabase();
    return _database;
  }

  _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    print("direc is $directory");
    String path = join(directory.path, _dbName);
    print("path is $path");
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) {
    db.execute('''
      CREATE TABLE $_tableName(
      $columnId INTEGER PRIMARY KEY,
      $columnName TEXT NOT NULL,
       $columnName2 TEXT NOT NULL)
      ''');
    db.execute('''
      CREATE TABLE $_tableName2(
      $columnId INTEGER PRIMARY KEY,
      $columnName TEXT NOT NULL,
       $columnName2 TEXT NOT NULL,
        $columnName3 TEXT NOT NULL)
      ''');
  }

  Future<int> insert(tableName, Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAll(tableName) async {
    Database db = await instance.database;
    return await db.query(tableName);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db
        .update(_tableName, row, where: '$columnId=?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(_tableName, where: '$columnId=?', whereArgs: [id]);
  }
}
