import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo/models/tasks.dart';
import 'package:todo/constants/new_task_type.dart';

class DatabaseHelper {
  static late final DatabaseHelper _databaseHelper =
      DatabaseHelper._createInstance();
  static Database? _database;

  DatabaseHelper._createInstance();
  factory DatabaseHelper() => _databaseHelper;

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    String path = join(await getDatabasesPath(), 'todo.db');
    var tasksDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return tasksDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT,
        title TEXT,
        description TEXT,
        isCompleted INTEGER,
        timeAdded TEXT
      )
    ''');
  }

  Future<int> insertTask(Task task) async {
    Database db = await database;
    var result = await db.insert('tasks', {
      'type': task.type.toString().split('.').last,
      'title': task.title,
      'description': task.description,
      'isCompleted': task.isCompleted ? 1 : 0,
      'timeAdded': task.timeAdded,
    });
    return result;
  }

  Future<List<Task>> getTasks() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('tasks');
    return List.generate(maps.length, (i) {
      return Task(
        id: maps[i]['id'],
        type: convertStringToTaskType(maps[i]['type']),
        title: maps[i]['title'],
        description: maps[i]['description'],
        isCompleted: maps[i]['isCompleted'] == 1 ? true : false,
        timeAdded: maps[i]['timeAdded'],
      );
    });
  }

  Future<int> updateTask(Task task) async {
    Database db = await database;
    return await db
        .update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<int> deleteTask(int id) async {
    Database db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  TaskType convertStringToTaskType(String taskTypeString) {
    switch (taskTypeString) {
      case 'morning':
        return TaskType.morning;
      case 'afternoon':
        return TaskType.afternoon;
      case 'evening':
        return TaskType.evening;
      default:
        return TaskType.unknown;
    }
  }

  Future<bool> _checkTitleUnique(String title) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      columns: ['title'],
      where: 'title = ?',
      whereArgs: [title],
    );
    return maps.isEmpty;
  }
}
