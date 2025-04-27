import 'package:doko/models/task.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  // Projects Table
  final String _projectsTableName = "project_table";
  final String _projectId = "project_id";
  final String _projectName = "project_name";
  final String _projectDesc = "project_description";
  
  // Task Table
  final String _taskTableName = "task_table";
  final String _taskId = "id";
  final String _taskName = "task_name";
  final String _taskDesc = "task_description";
  final String _taskDate = "task_date_deadline";
  final String _taskTime = "task_time_deadline";
  final String _taskIsDone = "is_done";

  DatabaseService._constructor();
  
  Future<Database> get database async {
    if(_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: _onCreate,
    );
    return database;
  }

  Future _onCreate (Database db, int version) async {
    // Projects table
    await db.execute('''
      CREATE TABLE $_projectsTableName (
        $_projectId INTEGER PRIMARY KEY,
        $_projectName TEXT NOT NULL,
        $_projectDesc TEXT
      )
    ''');

    // Task Table
    await db.execute('''
      CREATE TABLE $_taskTableName (
        $_taskId INTEGER PRIMARY KEY,
        $_taskName TEXT NOT NULL,
        $_taskDesc TEXT,
        $_taskDate TEXT NOT NULL,
        $_taskTime TEXT NOT NULL,
        $_taskIsDone INTEGER DEFAULT 0
      )
    ''');
  }

  // Task CRUD
  Future<int> addTask(String taskName, String description, String date, String time) async {
    final db = await database;
    return await db.insert(
      _taskTableName,{
        _taskName: taskName,
        _taskDesc: description,
        _taskDate: date,
        _taskTime: time,
        _taskIsDone: 0 // Default value (0 = belum selesai)
      }
    );
  }


  Future<int> editTask(Task task) async {
    final db = await database;
    return await db.update(
      _taskTableName,
      {
        _taskName: task.title,
        _taskDesc: task.description,
        _taskDate: task.date,
        _taskTime: task.time,
        _taskIsDone: task.isDone ? 1 : 0
      },
      where: '$_taskId = ?',
      whereArgs: [task.id],
    );
  }

  Future<List<Task>> getTask() async {
    final db = await database;
    final data = await db.query(_taskTableName);
    List<Task> tasks = data.map(
      (e) => Task(
        id: e[_taskId] as int?,
        title: e[_taskName] as String, 
        description: e[_taskDesc] as String?,
        date: e[_taskDate] as String, 
        time: e[_taskTime] as String,
        isDone: (e[_taskIsDone] as int) == 1,
      )
    ).toList();

    return tasks;
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      _taskTableName,
      where: '$_taskId = ?',
      whereArgs: [id],
    );
  }
}