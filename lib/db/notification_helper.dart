import 'package:sqflite/sqflite.dart';

import 'db_provider.dart';
import 'package:app/models/notification_model.dart';

class NotificationHelper {
  static const _tableName = 'notification';

  Future<int> insertNotification(NotificationModel notification) async {
    final db = await DBProvider.database;
    return await db.insert(
      _tableName,
      notification.toMap()
    );
  }

  // Insert more than 1 notification
  Future<void> insertNotifications(List<NotificationModel> notifications) async {
    final db = await DBProvider.database;
    final batch = db.batch();

    for (var notification in notifications) {
      batch.insert(
        _tableName,
        notification.toMap()
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<NotificationModel>> getAllNotification() async {
    final db = await DBProvider.database;
    final getData = await db.query(
      _tableName,
      orderBy: 'scheduled_time DESC'
    );
    return getData.map((map) => NotificationModel.fromMap(map)).toList();
  }

  Future<List<NotificationModel>> getNotificationsByTaskId(int taskId) async {
    final db = await DBProvider.database;
    final result = await db.query(
      'notification',
      where: 'task_id = ?',
      whereArgs: [taskId],
      orderBy: 'scheduled_time ASC',
    );
    return result.map((map) => NotificationModel.fromMap(map)).toList();
  }

  Future<List<NotificationModel>> getUnreadNotification() async {
    final db = await DBProvider.database;
    final getData = await db.query(
      _tableName,
      where: 'is_read = ?',
      whereArgs: [0],
      orderBy: 'scheduled_time DESC'
    );
    return getData.map((map) => NotificationModel.fromMap(map)).toList();
  }

  Future<int> updateNotification(NotificationModel notification) async {
    final db = await DBProvider.database;
    return await db.update(
      _tableName,
      notification.toMap(),
      where: 'id = ?',
      whereArgs: [notification.id],
    );
  }

  Future<int> markNotificationAsDelivered(int notificationId) async {
    final db = await DBProvider.database;
    return await db.update(
      'notification',
      {'is_delivered': 1},
      where: 'id = ?',
      whereArgs: [notificationId],
    );
  }

  // Mark Notification as Read
  Future<int> markNotificationAsRead(int notificationId) async {
    final db = await DBProvider.database;
    return await db.update(
      _tableName,
      {'is_read': 1},
      where: 'id = ?',
      whereArgs: [notificationId]
    );
  }

  Future<int> markAllNotificationsAsRead() async {
    final db = await DBProvider.database;
    return await db.update(
      'notification',
      {'is_read': 1},
      where: 'is_read = ?',
      whereArgs: [0],
    );
  }

  Future<int> deleteNotification(int id) async {
    final db = await DBProvider.database;
    return await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteNotificationsByTaskId(int taskId) async {
    final db = await DBProvider.database;
    return await db.delete(
      _tableName,
      where: 'task_id = ?',
      whereArgs: [taskId]
    );
  }

  Future<int> getNotificationCountForTask(int taskId) async {
    final db = await DBProvider.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM notification WHERE task_id = ?',
      [taskId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getUnreadNotificationCount() async {
    final db = await DBProvider.database;
    final getData = await db.rawQuery(
      'SELECT COUNT(*) as count FROM notification WHERE is_read = 0'
    );
    return Sqflite.firstIntValue(getData) ?? 0;
  }

  Future<int> cleanupOldNotifications() async {
    final db = await DBProvider.database;
    final thirtyDaysAgo = DateTime.now().subtract(Duration(days: 30));
    return await db.delete(
      'notification',
      where: 'is_delivered = 1 AND created_at < ?',
      whereArgs: [thirtyDaysAgo.toIso8601String()],
    );
  }
}