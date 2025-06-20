import 'package:app/components/task_group_card.dart';
import 'package:app/constants/app_string.dart';
import 'package:app/constants/colors.dart';
import 'package:app/db/task_group_db_helper.dart';
import 'package:app/models/task_group_model.dart';
import 'package:app/pages/add_group_page.dart';
import 'package:app/pages/detail_group_page.dart';
import 'package:flutter/material.dart';

class TaskGroupPage extends StatefulWidget {
  const TaskGroupPage({super.key});

  @override
  State<TaskGroupPage> createState() => _TaskGroupPageState();
}

class _TaskGroupPageState extends State<TaskGroupPage> {
  List<TaskGroup> taskGroups = [];
  List<TaskGroup> displayedGroups = [];
  final TextEditingController _searchController = TextEditingController();
  String sortBy = 'name';
  bool isAscending = true;

  @override
  void initState() {
    super.initState();
    initTaskGroups();
  }

  void initTaskGroups() async {
    taskGroups = await TaskGroupDBHelper.getTaskGroups();
    setState(() {
      displayedGroups = taskGroups;
    });
  }

  void sortTaskGroups(String criteria) {
    setState(() {
      sortBy = criteria;
      if (criteria == 'name') {
        displayedGroups.sort(
          (a, b) =>
              isAscending ? a.name.compareTo(b.name) : b.name.compareTo(a.name),
        );
      } else if (criteria == 'date') {
        displayedGroups.sort(
          (a, b) =>
              isAscending
                  ? DateTime.parse(
                    a.createdAt,
                  ).compareTo(DateTime.parse(b.createdAt))
                  : DateTime.parse(
                    b.createdAt,
                  ).compareTo(DateTime.parse(a.createdAt)),
        );
      }
    });
  }

  void toggleSortOrder() {
    setState(() {
      isAscending = !isAscending;
      sortTaskGroups(sortBy);
    });
  }

  void searchGroups(String query) {
    if (query.isEmpty) {
      setState(() {
        displayedGroups = taskGroups;
      });
      return;
    }

    final filtered =
        taskGroups.where((group) {
          final nameLower = group.name.toLowerCase();
          final queryLower = query.toLowerCase();
          return nameLower.contains(queryLower);
        }).toList();

    setState(() {
      displayedGroups = filtered;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appString = AppString(context);
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Container(
                height: 184,
                padding: EdgeInsets.symmetric(horizontal: 28),
                decoration: BoxDecoration(color: Color(0xFF7E1AD1)),
                child: Column(
                  children: [
                    SizedBox(height: 60),

                    Center(
                      child: Text(
                        appString.taskGroupTitle,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 12),
                      height: 36,
                      child: TextField(
                        controller: _searchController,
                        onChanged: searchGroups,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search, color: gray3),
                          filled: true,
                          fillColor: white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 4),
                        ),
                        style: TextStyle(
                          color: Color(0xFF7E1AD1),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Text(
                                    "${appString.sortBy}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),

                                GestureDetector(
                                  onTap: () => sortTaskGroups('name'),
                                  child: Container(
                                    width: 60,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color:
                                          sortBy == 'name'
                                              ? Color(0xFFBF8DE8)
                                              : Color(0xFF7E1AD1),
                                      borderRadius: BorderRadius.circular(10),
                                      border:
                                          sortBy != 'name'
                                              ? Border.all(
                                                color: Color(0xFFBF8DE8),
                                                width: 1,
                                              )
                                              : null,
                                    ),
                                    child: Center(
                                      child: Text(
                                        appString.name,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                GestureDetector(
                                  onTap: () => sortTaskGroups('date'),
                                  child: Container(
                                    width: 60,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color:
                                          sortBy == 'date'
                                              ? Color(0xFFBF8DE8)
                                              : Color(0xFF7E1AD1),
                                      borderRadius: BorderRadius.circular(10),
                                      border:
                                          sortBy != 'date'
                                              ? Border.all(
                                                color: Color(0xFFBF8DE8),
                                                width: 1,
                                              )
                                              : null,
                                    ),
                                    child: Center(
                                      child: Text(
                                        appString.date,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          GestureDetector(
                            onTap: toggleSortOrder,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Color(0xFFBF8DE8),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isAscending
                                    ? Icons.arrow_upward
                                    : Icons.arrow_downward,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddGroupPage(),
                          ),
                        );

                        if (result is TaskGroup) {
                          TaskGroup newGroupFromAddPage = result;
                          initTaskGroups();

                          if (mounted) {
                            final detailResult = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => DetailGroupPage(
                                      group: newGroupFromAddPage,
                                    ),
                              ),
                            );

                            if (detailResult == true) {
                              initTaskGroups();
                            }
                          }
                        } else if (result == true) {
                          initTaskGroups();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF7E1AD1),
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
                            Icon(Icons.add, size: 28, color: Colors.white),

                            SizedBox(width: 16),

                            Text(
                              appString.createGroup,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              Expanded(
                child:
                    displayedGroups.isEmpty
                        ? Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 32),
                            child: Text(
                              appString.noGroupNotifier,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        )
                        : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: ListView.separated(
                            padding: EdgeInsets.zero,
                            itemCount: displayedGroups.length,
                            itemBuilder: (context, index) {
                              final group = displayedGroups[index];
                              return GestureDetector(
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              DetailGroupPage(group: group),
                                    ),
                                  );

                                  if (result == true) {
                                    initTaskGroups();
                                  }
                                },
                                child: TaskGroupCard(
                                  name: group.name,
                                  description: group.description ?? '',
                                  notStartedCount: group.notStartedCount,
                                  ongoingCount: group.ongoingCount,
                                  completedCount: group.completedCount,
                                  createdAt: DateTime.parse(group.createdAt),
                                ),
                              );
                            },
                            separatorBuilder:
                                (context, index) => SizedBox(height: 16),
                          ),
                        ),
              ),
            ],
          );
        },
      ),
    );
  }
}
