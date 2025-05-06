import 'package:doko/components/task_group_card.dart';
import 'package:doko/db/task_group_db_helper.dart';
import 'package:doko/models/task_group_model.dart';
import 'package:doko/pages/add_group_page.dart';
import 'package:doko/pages/detail_group_page.dart';
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
        displayedGroups.sort((a, b) => a.name.compareTo(b.name));
      } else if (criteria == 'date') {
        displayedGroups.sort(
          (a, b) => DateTime.parse(
            b.createdAt,
          ).compareTo(DateTime.parse(a.createdAt)),
        );
      }
    });
  }

  void searchGroups(String query) {
    if (query.isEmpty) {
      setState(() {
        displayedGroups = taskGroups;
      });
      return;
    }

    final filtered = taskGroups.where((group) {
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
                        "Task Group",
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
                          prefixIcon: Icon(Icons.search, color: Colors.white),
                          filled: true,
                          fillColor: Color(0xFFD9D9D9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 4),
                        ),
                        style: TextStyle(
                            color: Color(0xFF7E1AD1),
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 12),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Text(
                              "Sort by:",
                              style: TextStyle(color: Colors.white, fontSize: 12),
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
                                  "Name",
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
                                  "Date",
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
                          MaterialPageRoute(builder: (context) => AddGroupPage()),
                        );

                        if (result == true) {
                          initTaskGroups();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                              "Create New Group",
                              style: TextStyle(color: Colors.white, fontSize: 16),
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
                            builder: (context) => DetailGroupPage(group: group),
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
                    // return TaskGroupCard(
                    //   name: group.name,
                    //   description: group.description ?? '',
                    //   notStartedCount: group.notStartedCount,
                    //   ongoingCount: group.ongoingCount,
                    //   completedCount: group.completedCount,
                    //   createdAt: DateTime.parse(group.createdAt),
                    // );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 16),
                ),
              ),
            ],
          );
        },
      )
    );
  }
}
