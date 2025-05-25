import 'package:app/components/calendar.dart';
import 'package:app/components/edit_task_bottom_sheet.dart';
import 'package:app/components/home_task_card.dart';
import 'package:app/db/task_db_helper.dart';
import 'package:app/db/task_group_db_helper.dart';
import 'package:app/models/task_model.dart';
import 'package:app/pages/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

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
    _fetchAllGroups();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await TaskDbHelper().getTask();
    setState(() {
      _allTask = tasks;
    });
  }

  Map<int?, String> groupNames = {};

  Future<void> _fetchAllGroups() async {
    final groups = await TaskGroupDBHelper.getTaskGroups();
    setState(() {
      groupNames = {for (var group in groups) group.id: group.name};
    });
  }

  @override
  Widget build(BuildContext context) {
    filteredTasks =
        _allTask.where((task) {
          DateTime taskDate = DateTime.parse(task.date);
          return isSameDate(taskDate, _selectedDate);
        }).toList();

    return Scaffold(
      body: Stack(
        children: [
          Container(height: 276, color: Color(0xFF7E1AD1)),
          Positioned(
            right: 16,
            top: 50,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Notification_Page()),
                );
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              highlightElevation: 0,
              splashColor: Colors.transparent, 
              shape: CircleBorder(
                side: BorderSide.none, 
              ),
              child: Icon(LucideIcons.bell, color: Colors.white),
            ),
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
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
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

                SizedBox(height: 8),

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

                        SizedBox(height: 8),

                        Expanded(
                          child:
                              filteredTasks.isEmpty
                                  ? Align(
                                    alignment: Alignment.topCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 32),
                                      child: Text(
                                        "You don't have any task for now!",
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
                                      final groupName =
                                          groupNames[task.task_group_id] ??
                                          "Unknown Group";

                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 12),
                                        child: HomeTaskCard(
                                          title: task.task_name,
                                          groupName: groupName,
                                          date: task.date,
                                          time: task.time,
                                          progress:
                                              (task.progress.toDouble() / 100),
                                          onTap: () async {
                                            final result = await showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                          top: Radius.circular(
                                                            20,
                                                          ),
                                                        ),
                                                  ),
                                              builder:
                                                  (context) =>
                                                      EditTaskBottomSheet(
                                                        task: task,
                                                      ),
                                            );

                                            if (result != null) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    (result['action'] ==
                                                            'delete')
                                                        ? "Task deleted"
                                                        : "Task updated",
                                                  ),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  margin: EdgeInsets.only(
                                                    bottom:
                                                        MediaQuery.of(
                                                          context,
                                                        ).viewInsets.bottom +
                                                        20,
                                                    left: 16,
                                                    right: 16,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                  duration: Duration(
                                                    seconds: 2,
                                                  ),
                                                ),
                                              );
                                              await _loadTasks();
                                            }
                                          },
                                        ),
                                      );
                                    },
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
