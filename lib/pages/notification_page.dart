import 'package:app/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:app/components/notification_card.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:app/db/notification_helper.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationHelper _notificationHelper = NotificationHelper();
  List<NotificationModel> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      final allNotifications = await _notificationHelper.getAllNotification();
      if (mounted) {
        setState(() {
          notifications = allNotifications;
        });
      }
    } catch(e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading notification: $e'),
          ),
        );
      }
    }
  }

  Future<void> _markAsRead(NotificationModel notification) async {
    if (!notification.isRead) {
      await _notificationHelper.markAllNotificationsAsRead();
      await _loadNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 129,
            color: const Color(0xFF7E1AD1),
            padding: const EdgeInsets.only(
              top: 48,
              left: 16,
              right: 16,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    LucideIcons.chevron_left,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Notifications',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.bell_off,
                        size: 64,
                        color: Colors.grey[600],
                      ),
                      SizedBox(height: 16,),
                      Text(
                        'No notifications yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  )
                )
            : NotificationCardList(
              notifications: notifications,
              onNotificationTap: _markAsRead,
            ),
          )
        ],
      ),
    );
  }
}