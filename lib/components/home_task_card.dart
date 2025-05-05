import 'package:flutter/material.dart';

class HomeTaskCard extends StatelessWidget {
  final String title;
  final String date;
  final String time;
  final double progress;
  final VoidCallback onTap;

  const HomeTaskCard({
    required this.title,
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
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                  fontSize: 16,
                ),
              ),

              Text(
                "$date, $time",
                style: TextStyle(
                  color: Colors.grey,
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