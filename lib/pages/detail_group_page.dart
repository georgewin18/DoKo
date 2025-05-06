import 'package:doko/components/add_task_bottom_sheet.dart';
import 'package:doko/components/task_card.dart';
import 'package:doko/components/edit_task_bottom_sheet.dart';
import 'package:doko/db/task_db_helper.dart';
import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../models/task_group_model.dart';
import 'package:doko/components/calendar.dart';

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

  List<Task> allTasks = [];

  // Menggunakan tanggal hari ini sebagai default
  String selectedDate = DateTime.now().toString().substring(0, 10);

  List<Task> get filteredTasks =>
      allTasks.where((task) => task.date == selectedDate).toList();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await TaskDbHelper().getTasksByGroup(widget.group.id);
    setState(() {
      allTasks = tasks;
    });
    debugPrint("berhasil reload");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // HEADER
          Container(
            height: 185,
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
                    Text(
                      widget.group.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 0),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.group.description ??
                                'No description available',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.edit, color: Colors.white70, size: 16),
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

                    debugPrint("Kalo modal sukses: $result");

                    if (result == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Task berhasil ditambahkan"),
                        ),
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
                        'Tidak ada tugas untuk tanggal $selectedDate',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.only(top: 15),
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];
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
                                      builder: (context) => EditTaskBottomSheet(task: task),
                                    );
                                    debugPrint(
                                      "Modal ditutup dengan result: $result",
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
                    ),
          ),
        ],
      ),
    );
  }
}
