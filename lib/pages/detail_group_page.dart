import 'package:doko/components/add_task_bottom_sheet.dart';
import 'package:doko/components/delete_confirmation_dialog.dart';
import 'package:doko/components/marquee.dart';
import 'package:doko/components/task_card.dart';
import 'package:doko/components/edit_task_bottom_sheet.dart';
import 'package:doko/components/edit_group_option.dart';
import 'package:doko/constants/colors.dart';
import 'package:doko/db/task_db_helper.dart';
import 'package:doko/db/task_group_db_helper.dart';
import 'package:doko/pages/edit_group_page.dart';
import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../models/task_group_model.dart';
import 'package:doko/components/calendar.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

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
    debugPrint("reload succeed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // HEADER (tidak scrollable)
            Container(
              height: 150,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFCFB1E7), Color(0xFF532199)],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context, true),
                      child: Container(
                        padding: EdgeInsets.only(
                          top: 8,
                          right: 8,
                          left: 8,
                          bottom: 30,
                        ),
                        child: Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final estCharWidth = 12.0;
                              final maxChars =
                                  (constraints.maxWidth / estCharWidth)
                                      .floor() -
                                  6;
                              return Marquee(
                                text: _group.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                speed: Duration(milliseconds: 500),
                                delay: Duration(seconds: 5),
                                revealUntilIndex: maxChars,
                                maxLines: 1,
                              );
                            },
                          ),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final estCharWidth = 4.2;
                              final maxChars =
                                  (constraints.maxWidth / estCharWidth).floor();
                              return Marquee(
                                text: _group.description ?? '',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                                speed: Duration(milliseconds: 250),
                                delay: Duration(seconds: 5),
                                revealUntilIndex: maxChars,
                                maxLines: 2,
                              );
                            },
                          ),
                          // Text(
                          //   _truncateDescription(_group.description ?? ''),
                          //   style: const TextStyle(
                          //     color: Colors.white70,
                          //     fontSize: 14,
                          //     overflow: TextOverflow.ellipsis,
                          //   ),
                          //   maxLines: 3,
                          // ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    Builder(
                      builder: (context) {
                        return GestureDetector(
                          onTapDown: (TapDownDetails details) async {
                            final RenderBox overlay =
                                Overlay.of(context).context.findRenderObject()
                                    as RenderBox;

                            final result = await editGroupOption(
                              context,
                              details,
                              overlay,
                            );

                            if (result == 'edit') {
                              final edited = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => EditGroupPage(group: _group),
                                ),
                              );
                              if (edited == true) {
                                await _reloadGroup();
                              }
                            } else if (result == 'delete') {
                              final confirmed = deleteGroupConfirmationDialog(
                                context,
                                _group,
                              );
                              if (confirmed == true) {
                                Navigator.pop(
                                  context,
                                  true,
                                ); // kembali ke TaskGroupPage dan beri sinyal "perlu reload"
                              }
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                              top: 8,
                              right: 8,
                              left: 8,
                              bottom: 30,
                            ),
                            child: Icon(
                              LucideIcons.ellipsis_vertical,
                              color: white,
                              size: 24,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // SISA HALAMAN YANG SCROLLABLE
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Calendar
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
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

                    // Header
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
                                    (context) => AddTaskBottomSheet(
                                      groupId: widget.group.id,
                                    ),
                              );
                              if (result == true) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Task has been added"),
                                  ),
                                );
                                _loadTasks();
                              }
                            },
                            child: const CircleAvatar(
                              radius: 14,
                              backgroundColor: Color(0xFF7E1AD1),
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                        height: 1,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Task List
                    if (filteredTasks.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Center(
                          child: Text(
                            'There is no task on\n$selectedDate',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
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
                                              result['action'] == 'delete'
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
                                      title: task.taskName,
                                      description: task.taskDesc ?? '',
                                      color: color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
