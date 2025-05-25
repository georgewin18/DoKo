
import 'package:flutter/material.dart';
import 'package:app/components/notification_card.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class Notification_Page extends StatelessWidget {
  const Notification_Page({Key? key}) : super(key: key);

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
            padding: const EdgeInsets.only(top: 48, left: 16, right: 16),
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
        Expanded(child: NotificationCardList()),
        ],
      ),
    );
  }
}