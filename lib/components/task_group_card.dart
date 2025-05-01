import 'package:doko/models/task_group_model.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

final List<TaskGroup> taskGroups = [
  TaskGroup(
    id: 1,
    name: "Data Structures",
    description:
        "This course covers fundamental data structures like arrays, linked lists, stacks, and queues, which are essential for solving computational problems efficiently. Students will learn about the implementation and applications of these structures in various algorithms.",
    createdAt: DateTime(2024, 5, 1).toIso8601String(),
    notStartedCount: 5,
    ongoingCount: 3,
    completedCount: 2,
  ),
  TaskGroup(
    id: 2,
    name: "Algorithms",
    description:
        "An in-depth exploration of algorithms, focusing on their design, analysis, and optimization. Topics include sorting, searching, and graph algorithms. The course also emphasizes algorithmic complexity and performance improvements.",
    createdAt: DateTime(2024, 4, 20).toIso8601String(),
    notStartedCount: 4,
    ongoingCount: 4,
    completedCount: 1,
  ),
  TaskGroup(
    id: 3,
    name: "Operating Systems",
    description:
        "Operating Systems is a comprehensive course that covers the design and management of computer systems, including processes, memory management, file systems, and I/O operations. Students will also gain an understanding of system calls and resource allocation.",
    createdAt: DateTime(2024, 4, 25).toIso8601String(),
    notStartedCount: 2,
    ongoingCount: 2,
    completedCount: 6,
  ),
  TaskGroup(
    id: 4,
    name: "Software Engineering",
    description:
        "A course that teaches the principles and practices of software development, focusing on the software development lifecycle, project management, and methodologies such as Agile and Waterfall.",
    createdAt: DateTime(2024, 5, 2).toIso8601String(),
    notStartedCount: 3,
    ongoingCount: 5,
    completedCount: 2,
  ),
  TaskGroup(
    id: 5,
    name: "Database Management",
    description:
        "This course introduces students to database systems, focusing on relational databases, SQL, data modeling, and normalization techniques. Students will learn how to design and query databases to manage large sets of structured data.",
    createdAt: DateTime(2024, 4, 28).toIso8601String(),
    notStartedCount: 1,
    ongoingCount: 5,
    completedCount: 4,
  ),
  TaskGroup(
    id: 6,
    name: "Computer Networks",
    description:
        "This course provides an overview of computer networking concepts, including network models, protocols, routing, and security. Students will gain practical skills in configuring networks and understanding how data is transmitted across the internet.",
    createdAt: DateTime(2024, 4, 30).toIso8601String(),
    notStartedCount: 6,
    ongoingCount: 2,
    completedCount: 2,
  ),
];

class TaskGroupCard extends StatelessWidget {
  final String name;
  final String description;
  final int notStartedCount;
  final int ongoingCount;
  final int completedCount;
  final DateTime createdAt;

  const TaskGroupCard({
    super.key,
    required this.name,
    required this.description,
    required this.notStartedCount,
    required this.ongoingCount,
    required this.completedCount,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 360,
        height: 104,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(top: 4, left: 16),
              child: CircularPercentIndicator(
                radius: 30.0,
                lineWidth: 12.0,
                percent: 0.7,
                animation: true,
                animationDuration: 1200,
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Colors.deepPurple,
              ),
            ),

            Container(
              padding: EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 12),
                    width: 260,
                    height: 24,
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7E1AD1),
                      ),
                    ),
                  ),

                  SizedBox(
                    width: 260,
                    height: 40,
                    child: Text(
                      description,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),

                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.circle, size: 8, color: Colors.red),
                          SizedBox(width: 4),
                          Text(
                            "${notStartedCount.toString()} Not Started",
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),

                      SizedBox(width: 12),

                      Row(
                        children: [
                          Icon(Icons.circle, size: 8, color: Colors.yellow),
                          SizedBox(width: 4),
                          Text(
                            "${ongoingCount.toString()} On Going",
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),

                      SizedBox(width: 12),

                      Row(
                        children: [
                          Icon(Icons.circle, size: 8, color: Colors.green),
                          SizedBox(width: 4),
                          Text(
                            "${completedCount.toString()} Completed",
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
