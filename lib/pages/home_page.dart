import 'package:doko/components/calendar.dart';
import 'package:doko/components/edit_task_bottom_sheet.dart';
import 'package:doko/components/home_task_card.dart';
import 'package:doko/db/task_db_helper.dart';
import 'package:doko/models/task_model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();

  List<Task> _allTask = [];
  List<Task> filteredTasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await TaskDbHelper().getTask();
    setState(() {
      _allTask = tasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    filteredTasks = _allTask.where((task) {
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
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  height: 388,
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
                    tasks: _allTask,
                  ),
                ),

                SizedBox(
                  height: 8,
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
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(
                          height: 8,
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
                                  groupName: "Kecerdasan Buatan",
                                  date: task.date,
                                  time: task.time,
                                  progress: (task.progress.toDouble() / 100),
                                  onTap: () async {
                                    final result = await showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20),
                                        ),
                                      ),
                                      builder: (context) => EditTaskBottomSheet(task: task),
                                    );

                                    if (result != null) {
                                      ScaffoldMessenger.of(context,).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            (result['action'] == 'delete') ? "Task berhasil dihapus" : "Task berhasil diupdate",
                                          ),
                                          behavior: SnackBarBehavior.floating,
                                          margin: EdgeInsets.only(
                                            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                                            left: 16,
                                            right: 16,
                                          ),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                          duration: Duration(seconds: 2)
                                        ),
                                      );
                                      await _loadTasks();
                                    }
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
