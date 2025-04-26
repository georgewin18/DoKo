import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

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
      onCreate: _onCreate,
    );
    return database;
  }

  Future _onCreate (Database db, int version) async {
    // Group Table
    final String _groupTableName = "Group_Table";
    final String _tableId = "Group_Id";
    final String _groupName = "Group_Name";
    final String _groupDesc = "Group_Description";

    // Task Table
    final String _taskTableName = "task_table";
    final String _taskId = "id";
    final String _taskName = "task_name";
    final String _taskDesc = "task_description";
    final String _date = "task_date_deadline";
    final String _time = "task_time_deadline";
    final String _isDone = "is_done";
    
    await db.execute('''
      CREATE TABLE $_groupTableName (
        $_tableId INTEGER PRIMARY KEY,
        $_groupName TEXT NOT NULL,
        $_groupDesc TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $_taskTableName (
        $_taskId INTEGER PRIMARY KEY,
        $_taskName TEXT NOT NULL,
        $_taskDesc TEXT,
        $_date TEXT NOT NULL,
        $_time TEXT NOT NULL,
        $_isDone INTEGER DEFAULT 0
      )
    ''');
  }
}