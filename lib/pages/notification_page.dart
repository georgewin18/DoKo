
import 'package:flutter/material.dart';
import 'package:app/components/notification_card.dart';

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
            color: const Color(0xFF6031A1),
            padding: const EdgeInsets.only(top: 48, left: 16, right: 16),
            child: Row(
              
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.arrow_back, color: Colors.white),
                const SizedBox(width: 16),
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