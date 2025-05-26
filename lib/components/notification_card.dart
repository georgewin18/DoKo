import 'package:app/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

// Widget untuk menampilkan daftar notifikasi
class NotificationCardList extends StatelessWidget {
  final List<NotificationModel> notifications;
  final Function(NotificationModel) onNotificationTap;

  const NotificationCardList({
    super.key,
    required this.notifications,
    required this.onNotificationTap,
  });

  IconData _getNotificationIconType(String type) {
    switch (type) {
      case '3_days':
        return LucideIcons.clock;
      case '1_day':
        return LucideIcons.calendar;
      case '6_hours':
        return LucideIcons.alarm_clock;
      case '3_hours':
        return LucideIcons.triangle_alert;
      default:
        return LucideIcons.bell;
    }
  }

  Color _getColorNotificationType(String type) {
    switch (type) {
      case '3_days':
        return Colors.blue;
      case '1_day':
        return Colors.orange;
      case '6_hours':
        return Colors.red[300]!;
      case '3_hours':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        final isRead = notification.isRead;

        return GestureDetector(
          onTap: () => onNotificationTap(notification),
          
          child: Card(
            elevation: isRead ? 1 : 3,
            color: isRead ? Colors.grey[50] : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: !isRead
                ? BorderSide(
                  color: Color(0xFF7E1AD1),
                  width: 1,
                )
                : BorderSide.none,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                notification.title,
                                style: TextStyle(
                                  fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                                  color: _getColorNotificationType(notification.notificationType),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            if (!isRead)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Color(0xFF7E1AD1),
                                  shape: BoxShape.circle
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4,),
                        Text(
                          notification.body,
                          style: TextStyle(
                            color: isRead ? Colors.grey : Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8,),
                        Text(
                          _formatDate(notification.createdAt),
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Icon(
                    _getNotificationIconType(notification.notificationType),
                    color: _getColorNotificationType(notification.notificationType),
                    size: 20,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}