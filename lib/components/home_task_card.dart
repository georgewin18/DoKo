import 'package:flutter/material.dart';

class HomeTaskCard extends StatelessWidget {
  final String title;
  final String groupName;
  final String date;
  final String time;
  final double progress;
  final VoidCallback onTap;

  const HomeTaskCard({
    required this.title,
    required this.groupName,
    required this.date,
    required this.time,
    required this.progress,
    required this.onTap
  });

  Color getProgressColor() {
    if (progress <= 0.2) {
      return Color(0xFFFF5454);
    } else if (progress <= 0.6) {
      return Color(0xFFF2B900);
    } else {
      return Color(0xFF38D300);
    }
  }

  bool isToday(String dateString) {
    final today = DateTime.now();
    final todayStr = "${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
    return dateString == todayStr;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7E1AD1),
                      fontSize: 16,
                    ),
                  ),

                  Text(
                    "${isToday(date) ? 'Today' : date}, $time",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 12
                    ),
                  )
                ],
              ),

              Text(
                groupName,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        valueColor: AlwaysStoppedAnimation<Color>(getProgressColor()),
                        backgroundColor: Colors.grey[300],
                        minHeight: 8,
                      ),
                    ),
                  ),

                  SizedBox(width: 8),

                  Text(
                    '${(progress * 100).toInt()}%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12
                    )
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}