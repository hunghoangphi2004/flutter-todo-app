import 'package:sqflite/sqflite.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/task_category.dart';

class DBHelper {
  static Database? _db;
  static final int _version = 1;
  static final String _tableName = 'tasks';

  // static Future<void> initDb() async {
  //   if (_db != null) {
  //     return;
  //   }
  //   try {
  //     String path = await getDatabasesPath() + '/tasks.db';
  //     _db = await openDatabase(
  //       path,
  //       version: _version,
  //       onCreate: (db, version) {
  //         print("Creating a new one");
  //         return db.execute('''
  //           CREATE TABLE IF NOT EXISTS $_tableName (
  //             id INTEGER PRIMARY KEY AUTOINCREMENT,
  //             title STRING,
  //             note TEXT,
  //             date STRING,
  //             isCompleted INTEGER,
  //             startTime STRING,
  //             endTime STRING,
  //             color INTEGER,
  //             remind INTEGER,
  //             repeat TEXT,
  //             category TEXT
  //           );

  //             CREATE TABLE IF NOT EXISTS task_categories (
  //             id INTEGER PRIMARY KEY AUTOINCREMENT,
  //             title TEXT,
  //             description TEXT,
  //             color INTEGER
  //           );
  //         ''');
  //       },
  //     );
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      String path = await getDatabasesPath() + '/tasks.db';
      _db = await openDatabase(
        path,
        version: _version,
        onCreate: (db, version) async {
          print("Creating a new one");
          // Tạo bảng tasks
          await db.execute('''
          CREATE TABLE IF NOT EXISTS $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title STRING,
            note TEXT,
            date STRING,
            isCompleted INTEGER,
            startTime STRING,
            endTime STRING,
            color INTEGER,
            remind INTEGER,
            repeat TEXT,
            category TEXT
          );
        ''');

          // Tạo bảng task_categories
          await db.execute('''
          CREATE TABLE IF NOT EXISTS task_categories (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            color INTEGER
          );
        ''');
        },
      );
    } catch (e) {
      print("Error: $e");
    }
  }

  //xu ly task
  static Future<int> insert(Task? task) async {
    print("task insert function called");
    return await _db!.insert(_tableName, task!.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print("task query function called");
    return await _db!.query(_tableName);
  }

  static delete(Task task) async {
    return await _db!.delete(_tableName, where: 'id=?', whereArgs: [task.id]);
  }

  static update(int id) async {
    return await _db!.rawUpdate(
      '''
      UPDATE tasks
      SET isCompleted = ?
      WHERE id = ?
      ''',
      [1, id],
    );
  }

  //xu ly task

  //xu ly category
  static Future<int> insertCategory(TaskCategory? category) async {
    print("task category insert function called");
    return await _db!.insert('task_categories', category!.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> queryCategories() async {
    return await _db!.query('task_categories');
  }

  static Future<int> deleteCategory(int id) async {
    return await _db!.delete(
      'task_categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> updateCategory(TaskCategory category) async {
    print("update category called");
    return await _db!.update(
      'task_categories',
      category.toJson(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  static Future<List<Map<String, dynamic>>> queryTasksByCategory(
    String category,
  ) async {
    print("Query tasks by category: $category");
    return await _db!.query(
      _tableName,
      where: 'category = ?',
      whereArgs: [category],
    );
  }

  //xu ly category
}
