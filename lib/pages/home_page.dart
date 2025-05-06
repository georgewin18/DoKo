import 'package:doko/components/calendar.dart';
import 'package:doko/components/edit_task_bottom_sheet.dart';
import 'package:doko/components/home_task_card.dart';
import 'package:doko/models/task_model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();

  final List<Task> _dummyTask = [
    Task(
        id: 1,
        task_name: 'Tugas 6: Algoritma Genetika',
        task_desc: 'Menyesuaikan PPT',
        task_reminder: '1 day before',
        date: '2025-05-04',
        time: '08:00',
        progress: 30,
        task_group_id: 1
    ),
    Task(
        id: 2,
        task_name: 'Tugas 6: Algoritma Genetika',
        task_desc: 'Menyesuaikan PPT',
        task_reminder: '2 days before',
        date: '2025-05-17',
        time: '09:00',
        progress: 50,
        task_group_id: 1
    ),
    Task(
        id: 3,
        task_name: 'Tugas 6: Algoritma Genetika',
        task_desc: 'Menyesuaikan PPT',
        task_reminder: '1 day before',
        date: '2025-05-08',
        time: '10:00',
        progress: 20,
        task_group_id: 1
    ),
  ];

  late List<Task> filteredTasks;

  @override
  Widget build(BuildContext context) {
    filteredTasks = _dummyTask.where((task) {
      DateTime taskDate = DateTime.parse(task.date);
      return isSameDate(taskDate, _selectedDate);
    }).toList();

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 276,
            color: Color(0xFF7E1AD1),
          ),

          Container(
            margin: EdgeInsets.only(top: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      Text(
                        "Manage your task with DoKo",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),

                SizedBox(
                  height: 8,
                ),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  height: 432,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                  ),
                  child: Calendar(
                    isHomepage: true,
                    onDateSelected: (date) {
                      setState(() {
                        _selectedDate = DateTime.parse(date);
                      });
                    },
                    tasks: _dummyTask,
                  ),
                ),

                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Task List",
                          style: TextStyle(
                            color: Color(0xFF7E1AD1),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(
                          height: 4,
                        ),

                        Expanded(
                          child: filteredTasks.isEmpty
                            ? Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 32),
                              child: Text(
                                "Tidak ada task untuk sekarang",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          )
                            : ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: filteredTasks.length,
                            itemBuilder: (context, index) {
                              final task = filteredTasks[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: 12),
                                child: HomeTaskCard(
                                  title: task.task_name,
                                  date: task.date,
                                  time: task.time,
                                  progress: (task.progress.toDouble() / 100),
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20),
                                        ),
                                      ),
                                      builder: (context) => EditTaskBottomSheet(task: task),
                                    );
                                  },
                                ),
                              );
                            }
                          ),
                        )
                      ]
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
