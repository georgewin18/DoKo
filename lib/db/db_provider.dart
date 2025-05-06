import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  static Database? _db;
  static const String _dbName = 'task_manager.db';
  static const int _dbVersion = 1;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE task_group (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        description TEXT,
        created_at TEXT NOT NULL,
        not_started_count INTEGER DEFAULT 0,
        ongoing_count INTEGER DEFAULT 0,
        completed_count INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE task (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        desc TEXT,
        attachment TEXT,
        reminder TEXT NOT NULL,
        date TEXT NOT NULL,
        time TEXT NOT NULL,
        progress INTEGER,
        task_group_id INTEGER,
        FOREIGN KEY (task_group_id) REFERENCES task_group(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TRIGGER update_taskgroup_count_after_insert
        AFTER INSERT ON task
        BEGIN
          UPDATE task_group
          SET 
            not_started_count = not_started_count + CASE WHEN NEW.progress = 0 THEN 1 ELSE 0 END,
            ongoing_count = ongoing_count + CASE WHEN NEW.progress > 0 AND NEW.progress < 100 THEN 1 ELSE 0 END,
            completed_count = completed_count + CASE WHEN NEW.progress = 100 THEN 1 ELSE 0 END
          WHERE id = NEW.task_group_id;
        END;
    ''');

    await db.execute('''
      CREATE TRIGGER update_taskgroup_count_after_update
        AFTER UPDATE OF progress ON task
        BEGIN
          UPDATE task_group
          SET 
            not_started_count = not_started_count - CASE WHEN OLD.progress = 0 THEN 1 ELSE 0 END,
            ongoing_count = ongoing_count - CASE WHEN OLD.progress > 0 AND OLD.progress < 100 THEN 1 ELSE 0 END,
            completed_count = completed_count - CASE WHEN OLD.progress = 100 THEN 1 ELSE 0 END
          WHERE id = OLD.task_group_id;

          UPDATE task_group
          SET 
            not_started_count = not_started_count + CASE WHEN NEW.progress = 0 THEN 1 ELSE 0 END,
            ongoing_count = ongoing_count + CASE WHEN NEW.progress > 0 AND NEW.progress < 100 THEN 1 ELSE 0 END,
            completed_count = completed_count + CASE WHEN NEW.progress = 100 THEN 1 ELSE 0 END
          WHERE id = NEW.task_group_id;
        END;
    ''');

    await db.execute('''
      CREATE TRIGGER update_taskgroup_count_after_delete
        AFTER DELETE ON task
        BEGIN
          UPDATE task_group
          SET 
            not_started_count = not_started_count - CASE WHEN OLD.progress = 0 THEN 1 ELSE 0 END,
            ongoing_count = ongoing_count - CASE WHEN OLD.progress > 0 AND OLD.progress < 100 THEN 1 ELSE 0 END,
            completed_count = completed_count - CASE WHEN OLD.progress = 100 THEN 1 ELSE 0 END
          WHERE id = OLD.task_group_id;
        END;
    ''');
  }
}