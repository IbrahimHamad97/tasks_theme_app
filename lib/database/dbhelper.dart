import 'package:sqflite/sqflite.dart';
import 'package:tasks_theme_app/models/task_model.dart';

class DBHelper {
  static Database? _db;
  static final int _version = 1;
  static final String _tableName = "tasks";

  static Future<void> initDB() async {
    String _path = await getDatabasesPath() + 'tasks.db';
    if (_db != null) {
      return;
    }
    try {
      _db =
      await openDatabase(_path, version: _version, onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE $_tableName(id INTEGER PRIMARY KEY AUTOINCREMENT,'
                'title STRING, note TEXT, date STRING, startTime STRING,'
                ' endTime STRING, remind INTEGER, repeat STRING,'
                ' color INTEGER, isCompleted INTEGER)');
      });
    }
    catch (e) {
      print(e);
    }
  }

  static Future<int> insert(Task? task) async {
    return await _db?.insert(_tableName, task!.toJson())??0;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    return await _db!.query(_tableName);
  }

  static delete(Task task) async {
    await _db!.delete(_tableName, where: 'id=?', whereArgs: [task.id]);
  }

  static update(int id, int status) async {
    await _db!.rawUpdate('''
      UPDATE tasks
      SET isCompleted = ?
      WHERE id = ?
    ''', [status, id]);
  }

}