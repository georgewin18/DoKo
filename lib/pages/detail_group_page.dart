import 'package:app/components/add_task_bottom_sheet.dart';
import 'package:app/components/task_card.dart';
import 'package:app/components/edit_task_bottom_sheet.dart';
import 'package:app/db/task_db_helper.dart';
import 'package:app/db/task_group_db_helper.dart';
import 'package:app/pages/edit_group_page.dart';
import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../models/task_group_model.dart';
import 'package:app/components/calendar.dart';

class DetailGroupPage extends StatefulWidget {
  final TaskGroup group;

  const DetailGroupPage({super.key, required this.group});

  @override
  State<DetailGroupPage> createState() => _DetailGroupPageState();
}

class _DetailGroupPageState extends State<DetailGroupPage> {
  List<Color> cardColors = [
    const Color(0xFF7E1AD1),
    const Color(0xFFBD00F2),
    const Color(0xFFD239E0),
    const Color(0xFFE045B1),
  ];

  late TaskGroup _group;
  List<Task> allTasks = [];

  // Menggunakan tanggal hari ini sebagai default
  String selectedDate = DateTime.now().toString().substring(0, 10);

  List<Task> get filteredTasks =>
      allTasks.where((task) => task.date == selectedDate).toList();

  @override
  void initState() {
    super.initState();
    _group = widget.group;
    _loadTasks();
  }

  Future<void> _reloadGroup() async {
    final updatedGroup = await TaskGroupDBHelper.getTaskGroupById(_group.id);
    if (updatedGroup != null) {
      setState(() {
        _group = updatedGroup;
      });
    }
  }

  Future<void> _loadTasks() async {
    final tasks = await TaskDbHelper().getTasksByGroup(_group.id);
    setState(() {
      allTasks = tasks;
    });
  }

  String _truncateDescription(String description) {
    // Ganti enter dengan spasi
    String clean = description.replaceAll('\n', ' ');

    // Potong jika lebih dari 75 karakter
    if (clean.length > 75) {
      return '${clean.substring(0, 75)}...';
    }
    return clean;
  }

  List<Task> getSortedTasks(List<Task> tasks) {
    final List<Task> sortedTasks = List.from(tasks);
    sortedTasks.sort((a, b) {
      final timeA = TimeOfDay(
        hour: int.parse(a.time.split(':')[0]),
        minute: int.parse(a.time.split(':')[1]),
      );
      final timeB = TimeOfDay(
        hour: int.parse(b.time.split(':')[0]),
        minute: int.parse(b.time.split(':')[1]),
      );

      return timeA.hour.compareTo(timeB.hour) != 0
          ? timeA.hour.compareTo(timeB.hour)
          : timeA.minute.compareTo(timeB.minute);
    });
    return sortedTasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // HEADER
          Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
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
                      onTap: () => Navigator.pop(context, true),
                      child: const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          _group.name.length > 18
                              ? '${_group.name.substring(0, 18)}...'
                              : _group.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => EditGroupPage(group: _group),
                              ),
                            );

                            if (result == true) {
                              await _reloadGroup();
                            }
                          },
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white70,
                            size: 24,
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _truncateDescription(
                              _group.description ?? 'No description available',
                            ),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // CALENDAR - Dengan callback onDateSelected
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Calendar(
              isHomepage: false,
              tasks: allTasks,
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date.toString().substring(0, 10);
                });
              },
            ),
          ),

          // TASK HEADER
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 20, 30, 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Task',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4D107F),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final result = await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder:
                          (context) =>
                              AddTaskBottomSheet(groupId: widget.group.id),
                    );

                    if (result == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Task Added")),
                      );
                      _loadTasks();
                    }
                  },
                  child: const CircleAvatar(
                    radius: 14,
                    backgroundColor: Color(0xFF7E1AD1),
                    child: Icon(Icons.add, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Divider(color: Colors.grey, thickness: 1, height: 1),
          ),

          // TASK LIST
          Expanded(
            child:
                filteredTasks.isEmpty
                    ? Center(
                      child: Text(
                        'No Task For $selectedDate',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                    : (() {
                      final sortedTasks = getSortedTasks(filteredTasks);

                      return ListView.builder(
                        padding: const EdgeInsets.only(top: 15),
                        itemCount: sortedTasks.length,
                        itemBuilder: (context, index) {
                          final task = sortedTasks[index];
                          final color = cardColors[index % cardColors.length];

                          return Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 60,
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    task.time,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      final result = await showModalBottomSheet(
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

                                      if (result != null) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              (result['action'] == 'delete')
                                                  ? "Task deleted"
                                                  : "Task updated",
                                            ),
                                            behavior: SnackBarBehavior.floating,
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
                                                  BorderRadius.circular(12),
                                            ),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                        await _loadTasks();
                                      }
                                    },
                                    child: TaskCard(
                                      task: task,
                                      title: task.task_name,
                                      description: task.task_desc ?? '',
                                      color: color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    })(),
          ),
        ],
      ),
    );
  }
}
