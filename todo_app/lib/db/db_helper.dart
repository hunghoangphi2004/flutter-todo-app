import 'package:sqflite/sqflite.dart';
import 'package:todo_app/models/task.dart';

class DBHelper {
  static Database? _db;
  static final int _version = 2;  // Tăng version lên 2
  static final String _taskTable = 'tasks';
  static final String _categoryTable = 'categories'; // Bảng category

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      String path = await getDatabasesPath() + 'tasks.db';
      _db = await openDatabase(
        path,
        version: _version,
        onCreate: (db, version) {
          print("Creating new database...");
          db.execute('''
            CREATE TABLE $_taskTable (
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
            )
          ''');
          db.execute('''
            CREATE TABLE $_categoryTable (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name STRING,
              description TEXT,
              color STRING
            )
          ''');
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            await db.execute('''
              CREATE TABLE $_categoryTable (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name STRING,
                description TEXT,
                color STRING
              )
            ''');
            print("Categories table created via onUpgrade!");
          }
        },
      );
    } catch (e) {
      print("Database init error: $e");
    }
  }

  // Thêm task mới
  static Future<int> insert(Task? task) async {
    print("Insert task function called");
    return await _db!.insert(_taskTable, task!.toJson()) ?? 1;
  }

  // Lấy danh sách task
  static Future<List<Map<String, dynamic>>> query() async {
    print("Query task function called");
    return await _db!.query(_taskTable);
  }

  // Xóa task
  static delete(Task task) async {
    return await _db!.delete(_taskTable, where: 'id=?', whereArgs: [task.id]);
  }

  // Cập nhật trạng thái task
  static update(int id) async {
    return await _db!.rawUpdate(
      '''
      UPDATE $_taskTable
      SET isCompleted = ?
      WHERE id = ?
      ''',
      [1, id],
    );
  }

  // Thêm category mới
  static Future<int> insertCategory(String name, String description, String color) async {
    print("Insert category function called");
    return await _db!.insert(_categoryTable, {
      'name': name,
      'description': description,
      'color': color,
    }) ?? 1;
  }

  // Lấy danh sách category
  static Future<List<Map<String, dynamic>>> queryCategories() async {
    print("Query category function called");
    return await _db!.query(_categoryTable);
  }

  // Xóa category
  static deleteCategory(int id) async {
    return await _db!.delete(_categoryTable, where: 'id=?', whereArgs: [id]);
  }

  // Cập nhật category
  static updateCategory(int id, String name, String description, String color) async {
    return await _db!.update(
      _categoryTable,
      {'name': name, 'description': description, 'color': color},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
