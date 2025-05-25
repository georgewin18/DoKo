import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../models/task_model.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final String title;
  final String description;
  final Color color;

  const TaskCard({
    required this.task,
    required this.title,
    required this.description,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xff7E1AD1), width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              task.time,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          
          SizedBox(width: 12),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      child: Icon(
                        LucideIcons.link,
                        size: 16,
                        color: Color(0xff7E1AD1),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                
                if (description.isNotEmpty)
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                
                SizedBox(height: 8),
                
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: task.progress,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xff7E1AD1),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 100 - task.progress,
                              child: Container(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${task.progress}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}