import 'package:app/models/notification_model.dart';
import 'notification_helper.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  final NotificationHelper _notificationHelper = NotificationHelper();

  // Tambahkan timezone location untuk Indonesia
  static const String _indonesiaTimeZone = 'Asia/Jakarta';

  // Initialization Notification Service
  Future<void> initialize() async {
    tz.initializeTimeZones();
    
    // Set timezone location untuk Indonesia
    final jakarta = tz.getLocation(_indonesiaTimeZone);
    tz.setLocalLocation(jakarta);

    // Android Initialization
    const AndroidInitializationSettings androidInitializationSettings = 
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationOnTapped,
    );

    await _requestPermission();
  }

  Future<void> _requestPermission() async {
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation = 
          _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        await androidImplementation.requestNotificationsPermission();
        await androidImplementation.requestExactAlarmsPermission();
      }
    }
  }

  void _onNotificationOnTapped(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    
    if(payload != null) {
      final parts = payload.split('|');
      if(parts.length >= 2) {
        final taskId = int.tryParse(parts[0]);
        final notificationId = int.tryParse(parts[1]);

        if(notificationId != null) {
          await _notificationHelper.markNotificationAsRead(notificationId);
          // Mark notification as delivered juga
          await _notificationHelper.markNotificationAsDelivered(notificationId);
        }

        debugPrint('Notification tapped for taskId : $taskId');
      }
    }
  }

  Future<void> scheduleTaskNotification({
    required int taskId,
    required String taskName,
    required DateTime taskDeadline,
    String? taskDescription
  }) async {
    // Cancel existing notifications first
    await cancelTaskNotification(taskId);

    final now = DateTime.now();
    final notifications = <NotificationModel>[];

    final schedules = [
      {'duration': Duration(days: 3), 'type': NotificationType.threeDays},
      {'duration': Duration(days: 1), 'type': NotificationType.oneDay},
      {'duration': Duration(hours: 6), 'type': NotificationType.sixHours},
      {'duration': Duration(hours: 3), 'type': NotificationType.threeHours},
    ];

    for (var schedule in schedules) {
      final duration = schedule['duration'] as Duration;
      final type = schedule['type'] as NotificationType;
      final scheduledTime = taskDeadline.subtract(duration);

      if (scheduledTime.isAfter(now)) {
        final notificationId = _generateNotificationId(taskId, type.value);

        // Buat notification model dulu untuk mendapatkan ID
        final notification = NotificationModel(
          taskId: taskId, 
          title: type.defaultMessage, 
          body: 'Task: $taskName${taskDescription != null ? '\n$taskDescription' : ''}', 
          scheduledTime: scheduledTime, 
          notificationType: type.value,
        );

        notifications.add(notification);
      }
    }

    // Insert ke database dulu untuk mendapatkan ID
    if (notifications.isNotEmpty) {
      await _notificationHelper.insertNotifications(notifications);
      
      // Kemudian schedule notifikasinya
      final savedNotifications = await _notificationHelper.getNotificationsByTaskId(taskId);
      
      for (var notification in savedNotifications) {
        if (!notification.isDelivered && notification.scheduledTime.isAfter(now)) {
          final notificationId = _generateNotificationId(taskId, notification.notificationType);
          
          await _scheduleNotification(
            id: notificationId,
            title: notification.title,
            body: notification.body,
            scheduledTime: notification.scheduledTime,
            payload: '$taskId|${notification.id}',
          );
        }
      }
    }
  }

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'task_reminders',
      'Task Reminders',
      channelDescription: 'Notification for task deadlines',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      enableVibration: true,
      playSound: true,
      autoCancel: true,
      ongoing: false,
      showWhen: true,
      visibility: NotificationVisibility.public,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    try {
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );
      
      debugPrint('✅ Scheduled notification ID: $id for time: $scheduledTime');
    } catch (e) {
      debugPrint('❌ Error scheduling notification: $e');
    }
  }

  Future<void> cancelTaskNotification(int taskId) async {
    final types = [
      NotificationType.threeDays,
      NotificationType.oneDay,
      NotificationType.sixHours,
      NotificationType.threeHours,
    ];

    for (var type in types) {
      final notificationId = _generateNotificationId(taskId, type.value);
      await _notificationsPlugin.cancel(notificationId);
    }

    await _notificationHelper.deleteNotificationsByTaskId(taskId);
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  int _generateNotificationId(int taskId, String type) {
    final typeHash = type.hashCode;
    return taskId * 1000 + (typeHash % 1000).abs();
  }

  Future<void> rescheduleAllNotification() async {
    try {
      final notifications = await _notificationHelper.getAllNotification();
      final now = DateTime.now();
      int rescheduledCount = 0;

      for (var notification in notifications) {
        if (!notification.isDelivered && notification.scheduledTime.isAfter(now)) {
          final notificationId = _generateNotificationId(
            notification.taskId,
            notification.notificationType,
          );

          await _scheduleNotification(
            id: notificationId,
            title: notification.title,
            body: notification.body,
            scheduledTime: notification.scheduledTime,
            payload: '${notification.taskId}|${notification.id}'
          );
          
          rescheduledCount++;
        }
      }
      
      debugPrint('✅ Rescheduled $rescheduledCount notifications');
    } catch (e) {
      debugPrint('❌ Error rescheduling notifications: $e');
    }
  }

  Future<void> updateTaskNotifications({
    required int taskId,
    required String taskName,
    required DateTime taskDeadline,
    String? taskDescription,
  }) async {
    await scheduleTaskNotification(
      taskId: taskId, 
      taskName: taskName, 
      taskDeadline: taskDeadline,
      taskDescription: taskDescription,
    );
  }

  Future<Map<String, int>> getNotificationStats() async {
    final totalCount = (await _notificationHelper.getAllNotification()).length;
    final unreadCount = await _notificationHelper.getUnreadNotificationCount();

    return {
      'total': totalCount,
      'unread': unreadCount,
    };
  }

  Future<void> cleanupOldNotifications() async {
    await _notificationHelper.cleanupOldNotifications();
  }

  Future<void> showTestNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'test_channel',
      'Test Notifications',
      channelDescription: 'Test notification channel',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _notificationsPlugin.show(
      999,
      'Test Notification',
      'This is a test notification',
      platformChannelSpecifics,
    );
  }
}