import 'package:flutter/material.dart';

class NotificationItem {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;

  NotificationItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
  });
}

// Data dummy notifikasi
final List<NotificationItem> notifications = [
  NotificationItem(
    title: "Deadline for PdBL Project",
    description: "Blablablablebleblublublu\nBlablablablebleble",
    icon: Icons.warning_amber_rounded,
    iconColor: Colors.red,
  ),
  NotificationItem(
    title: "Reminder",
    description: "Reminder blablabla",
    icon: Icons.access_time_rounded,
    iconColor: Colors.blue,
  ),
  NotificationItem(
    title: "Reminder",
    description: "Reminder blablabla",
    icon: Icons.access_time_rounded,
    iconColor: Colors.blue,
  ),
  NotificationItem(
    title: "Deadline for PdBL Project",
    description: "Blablablablebleblublublu\nBlablablablebleble",
    icon: Icons.warning_amber_rounded,
    iconColor: Colors.red,
  ),
  NotificationItem(
    title: "Reminder",
    description: "Reminder blablabla",
    icon: Icons.access_time_rounded,
    iconColor: Colors.blue,
  ),
];

// Widget untuk menampilkan daftar notifikasi
class NotificationCardList extends StatelessWidget {
  const NotificationCardList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final notif = notifications[index];
        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
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
                      Text(
                        notif.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: notif.iconColor,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notif.description,
                        style: const TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Icon(notif.icon, color: notif.iconColor),
              ],
            ),
          ),
        );
      },
    );
  }
}