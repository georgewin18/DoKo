import 'package:sqflite/sqflite.dart';
import 'db_provider.dart';
import 'package:app/models/notification_model.dart';

class NotificationHelper {
  static const _tableName = 'notification';

  Future<int> insertNotification(NotificationModel notification) async {
    try {
      final db = await DBProvider.database;
      return await db.insert(
        _tableName,
        notification.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace, // Tambahkan untuk handle duplikasi
      );
    } catch (e) {
      print('❌ Error inserting notification: $e');
      rethrow;
    }
  }

  // Insert more than 1 notification
  Future<void> insertNotifications(List<NotificationModel> notifications) async {
    try {
      final db = await DBProvider.database;
      final batch = db.batch();

      for (var notification in notifications) {
        batch.insert(
          _tableName,
          notification.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit(noResult: true);
    } catch (e) {
      print('❌ Error inserting notifications: $e');
      rethrow;
    }
  }

  Future<List<NotificationModel>> getAllNotification() async {
    try {
      final db = await DBProvider.database;
      final getData = await db.query(
        _tableName,
        orderBy: 'scheduled_time DESC'
      );
      return getData.map((map) => NotificationModel.fromMap(map)).toList();
    } catch (e) {
      print('❌ Error getting all notifications: $e');
      return [];
    }
  }

  Future<List<NotificationModel>> getNotificationsByTaskId(int taskId) async {
    try {
      final db = await DBProvider.database;
      final result = await db.query(
        _tableName,
        where: 'task_id = ?',
        whereArgs: [taskId],
        orderBy: 'scheduled_time ASC',
      );
      return result.map((map) => NotificationModel.fromMap(map)).toList();
    } catch (e) {
      print('❌ Error getting notifications by task ID: $e');
      return [];
    }
  }

  Future<List<NotificationModel>> getUnreadNotification() async {
    try {
      final db = await DBProvider.database;
      final getData = await db.query(
        _tableName,
        where: 'is_read = ?',
        whereArgs: [0],
        orderBy: 'scheduled_time DESC'
      );
      return getData.map((map) => NotificationModel.fromMap(map)).toList();
    } catch (e) {
      print('❌ Error getting unread notifications: $e');
      return [];
    }
  }

  // Tambahan: Get pending notifications (belum delivered dan scheduledTime > now)
  Future<List<NotificationModel>> getPendingNotifications() async {
    try {
      final db = await DBProvider.database;
      final now = DateTime.now().toIso8601String();
      final getData = await db.query(
        _tableName,
        where: 'is_delivered = ? AND scheduled_time > ?',
        whereArgs: [0, now],
        orderBy: 'scheduled_time ASC'
      );
      return getData.map((map) => NotificationModel.fromMap(map)).toList();
    } catch (e) {
      print('❌ Error getting pending notifications: $e');
      return [];
    }
  }

  Future<int> updateNotification(NotificationModel notification) async {
    try {
      final db = await DBProvider.database;
      return await db.update(
        _tableName,
        notification.toMap(),
        where: 'id = ?',
        whereArgs: [notification.id],
      );
    } catch (e) {
      print('❌ Error updating notification: $e');
      return 0;
    }
  }

  Future<int> markNotificationAsDelivered(int notificationId) async {
    try {
      final db = await DBProvider.database;
      return await db.update(
        _tableName,
        {'is_delivered': 1},
        where: 'id = ?',
        whereArgs: [notificationId],
      );
    } catch (e) {
      print('❌ Error marking notification as delivered: $e');
      return 0;
    }
  }

  // Mark Notification as Read
  Future<int> markNotificationAsRead(int notificationId) async {
    try {
      final db = await DBProvider.database;
      return await db.update(
        _tableName,
        {'is_read': 1},
        where: 'id = ?',
        whereArgs: [notificationId]
      );
    } catch (e) {
      print('❌ Error marking notification as read: $e');
      return 0;
    }
  }

  Future<int> markAllNotificationsAsRead() async {
    try {
      final db = await DBProvider.database;
      return await db.update(
        _tableName,
        {'is_read': 1},
        where: 'is_read = ?',
        whereArgs: [0],
      );
    } catch (e) {
      print('❌ Error marking all notifications as read: $e');
      return 0;
    }
  }

  Future<int> deleteNotification(int id) async {
    try {
      final db = await DBProvider.database;
      return await db.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('❌ Error deleting notification: $e');
      return 0;
    }
  }

  Future<int> deleteNotificationsByTaskId(int taskId) async {
    try {
      final db = await DBProvider.database;
      return await db.delete(
        _tableName,
        where: 'task_id = ?',
        whereArgs: [taskId]
      );
    } catch (e) {
      print('❌ Error deleting notifications by task ID: $e');
      return 0;
    }
  }

  Future<int> getNotificationCountForTask(int taskId) async {
    try {
      final db = await DBProvider.database;
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM $_tableName WHERE task_id = ?',
        [taskId],
      );
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      print('❌ Error getting notification count for task: $e');
      return 0;
    }
  }

  Future<int> getUnreadNotificationCount() async {
    try {
      final db = await DBProvider.database;
      final getData = await db.rawQuery(
        'SELECT COUNT(*) as count FROM $_tableName WHERE is_read = 0'
      );
      return Sqflite.firstIntValue(getData) ?? 0;
    } catch (e) {
      print('❌ Error getting unread notification count: $e');
      return 0;
    }
  }

  Future<int> cleanupOldNotifications() async {
    try {
      final db = await DBProvider.database;
      final thirtyDaysAgo = DateTime.now().subtract(Duration(days: 30));
      return await db.delete(
        _tableName,
        where: 'is_delivered = 1 AND created_at < ?',
        whereArgs: [thirtyDaysAgo.toIso8601String()],
      );
    } catch (e) {
      print('❌ Error cleaning up old notifications: $e');
      return 0;
    }
  }

  // Tambahan: Method untuk debug/testing
  Future<void> printAllNotifications() async {
    try {
      final notifications = await getAllNotification();
      print('📋 All Notifications (${notifications.length}):');
      for (var notification in notifications) {
        print('   - ${notification.toString()}');
      }
    } catch (e) {
      print('❌ Error printing notifications: $e');
    }
  }
}