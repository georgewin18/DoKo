class NotificationModel {
  final int? id;
  final int taskId;
  final String title;
  final String body;
  final DateTime scheduledTime;
  final String notificationType; // 3_days, 1_day, 6_hours, 3_hours
  final bool isDelivered;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    this.id,
    required this.taskId,
    required this.title,
    required this.body,
    required this.scheduledTime,
    required this.notificationType,
    this.isDelivered = false,
    this.isRead = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task_id': taskId,
      'title': title,
      'body': body,
      'scheduled_time': scheduledTime,
      'notification_type': notificationType,
      'is_delivered': isDelivered ? 1 : 0,
      'is_read': isRead ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'],
      taskId: map['task_id'],
      title: map['title'],
      body: map['body'],
      scheduledTime: DateTime.parse(map['scheduled_time']),
      notificationType: map['notification_type'],
      isDelivered: map['is_delivered'] == 1,
      isRead: map['is_read'] == 1,
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  NotificationModel copyWith({
    int? id,
    int? taskId,
    String? title,
    String? body,
    DateTime? scheduledTime,
    String? notificationType,
    bool? isDelivered,
    bool? isRead,
    DateTime? createdAt
  }) {
    return NotificationModel(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      body: body ?? this.body,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      notificationType: notificationType ?? this.notificationType,
      isDelivered: isDelivered ?? this.isDelivered,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt
    );
  }

  @override
  String toString() {
    return 'NotificationModel{id: $id, taskId: $taskId, title: $title, scheduledTime: $scheduledTime, type: $notificationType}';
  }
}

enum NotificationType {
  threeDays('3_days', 'Reminder: Task due in 3 days'),
  oneDay('1_day', 'Reminder: Task due tomorrow'),
  sixHours('6_hours', 'Reminder: Task due in 6 hours'),
  threeHours('3_hours', 'Urgent: Task due in 3 hours');

  const NotificationType(this.value, this.defaultMessage);
  final String value;
  final String defaultMessage;

  static NotificationType fromValue(String value) {
    return NotificationType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => NotificationType.threeDays
    );
  }
}