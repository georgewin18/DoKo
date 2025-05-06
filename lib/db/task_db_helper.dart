import 'db_provider.dart';
import 'package:doko/models/task_model.dart';

class TaskDbHelper {
  static const String _tableName = 'task';
  static const String _taskId = 'id';
  static const String _taskName = 'name';
  static const String _taskDesc = 'desc';
  static const String _taskAttachment = 'attachment';
  static const String _taskReminder = 'reminder';
  static const String _taskDate = 'date';
  static const String _taskTime = 'time';
  static const String _taskProgress = 'progress';
  static const String _taskGroupId = 'task_group_id';

  Task _fromMapToTask(Map<String, Object?> e) => Task(
    id: e[_taskId] as int,
    task_name: e[_taskName] as String,
    task_desc: e[_taskDesc] as String?,
    task_attachment: e[_taskAttachment] as String?,
    task_reminder: e[_taskReminder] as String,
    date: e[_taskDate] as String,
    time: e[_taskTime] as String,
    progress: e[_taskProgress] as int? ?? 0,
    task_group_id: e[_taskGroupId] as int,
  );

  Future<int> addTask(
    String taskName,
    String? taskDesc,
    String? taskAttachment,
    String? reminder,
    String date,
    String time,
    int? progress,
    int? taskGroupId
  ) async {
    final db = await DBProvider.database;
    return await db.insert(
      _tableName,
      {
        _taskName: taskName,
        _taskDesc: taskDesc,
        _taskAttachment: taskAttachment,
        _taskReminder: reminder,
        _taskDate: date,
        _taskTime: time,
        _taskProgress: progress ?? 0,
        _taskGroupId: taskGroupId,
      }
    );
  }

  // Get All Task
  Future<List<Task>> getTask() async {
    final db = await DBProvider.database;
    final data = await db.query(_tableName);
    List<Task> tasks = data.map(_fromMapToTask).toList();
    return tasks;
  }

  // Get Task By Group
  Future<List<Task>> getTasksByGroup(int? groupId) async {
    final db = await DBProvider.database;
    final data = await db.query(
      _tableName,
      where: '$_taskGroupId = ?',
      whereArgs: [groupId],
    );
    List<Task> tasks = data.map(_fromMapToTask).toList();
    return tasks;
  }

  Future<int> updateTask(
    int? id,
    String taskName,
    String? taskDesc,
    String? taskAttachment,
    String taskReminder,
    String date,
    String time,
    int progress,
  ) async {
    final db = await DBProvider.database;
    return await db.update(
      _tableName,
      {
        _taskName: taskName,
        _taskDesc: taskDesc,
        _taskAttachment: taskAttachment,
        _taskReminder: taskReminder,
        _taskDate: date,
        _taskTime: time,
        _taskProgress: progress,
      },
      where: '$_taskId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTask(int? id) async {
    final db = await DBProvider.database;
    return await db.delete(_tableName, where: '$_taskId = ?', whereArgs: [id]);
  }
}
