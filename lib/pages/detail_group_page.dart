import 'package:doko/components/add_task_bottom_sheet.dart';
import 'package:doko/components/task_card.dart';
import 'package:doko/components/edit_task_bottom_sheet.dart';
import 'package:flutter/material.dart';
import '../models/task_model.dart';

class DetailGroupPage extends StatelessWidget {
  final List<Color> cardColors = [
    Color(0xFF7E1AD1),
    Color(0xFFBD00F2),
    Color(0xFFD239E0),
    Color(0xFFE045B1),
  ];

  final List<Task> dummyTasks = [
    Task(
      id: 1,
      task_name: 'Tugas 6: Algoritma Genetika',
      task_desc:
          'Menyesuaikan PPT Menyesuaikan PPT Menyesuaikan PPT Menyesuaikan PPT Menyesuaikan PPT Menyesuaikan PPT Menyesuaikan PPT Menyesuaikan PPT',
      task_reminder: '1 day before',
      date: '2025-05-04',
      time: '08:00',
      progress: 30,
    ),
    Task(
      id: 2,
      task_name: 'Tugas 6: Algoritma Genetika',
      task_desc: 'Menyesuaikan PPT',
      task_reminder: '2 days before',
      date: '2025-05-17',
      time: '09:00',
      progress: 50,
    ),
    Task(
      id: 3,
      task_name: 'Tugas 6: Algoritma Genetika',
      task_desc: 'Menyesuaikan PPT',
      task_reminder: '1 day before',
      date: '2025-05-08',
      time: '10:00',
      progress: 20,
    ),
    Task(
      id: 4,
      task_name: 'Tugas 6: Algoritma Genetika',
      task_desc: 'Menyesuaikan PPT',
      task_reminder: '3 days before',
      date: '2025-05-20',
      time: '11:00',
      progress: 80,
    ),
    Task(
      id: 5,
      task_name: 'Tugas 6: Algoritma Genetika',
      task_desc:
          'Menyesuaikan PPT Menyesuaikan PPT Menyesuaikan PPT Menyesuaikan PPT Menyesuaikan PPT Menyesuaikan PPT Menyesuaikan PPT Menyesuaikan PPT',
      task_reminder: '2 days before',
      date: '2025-05-13',
      time: '07:00',
      progress: 65,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 185,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFCFB1E7), Color(0xFF532199)],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 1,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Kecerdasan Buatan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 0),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Ini adalah deskripsi kecerdasan buatan',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            // Edit Logic
                          },
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white70,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Placeholder for calendar
          Container(
            height: 280,
            color: Colors.grey.shade200,
            alignment: Alignment.center,
            child: Text('Calendar Placeholder'),
          ),

          // My Task Header
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 20, 30, 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Task',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4D107F),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (context) => const AddTaskBottomSheet(),
                    );
                  },
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: const Color(0xFF7E1AD1),
                    child: const Icon(Icons.add, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Divider(color: Colors.grey, thickness: 1, height: 1),
          ),

          // Scrollable Task List
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 15),
              itemCount: dummyTasks.length,
              itemBuilder: (context, index) {
                final task = dummyTasks[index];
                final color = cardColors[index % cardColors.length];
                return Padding(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 60,
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          task.time,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder:
                                  (context) => EditTaskBottomSheet(task: task),
                            );
                          },
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                builder:
                                    (context) =>
                                        EditTaskBottomSheet(task: task),
                              );
                            },
                            child: TaskCard(
                              title: task.task_name,
                              description: task.task_desc ?? '',
                              color: color,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
