import 'package:app/constants/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter/services.dart';
import 'package:app/models/task_group_model.dart';
import 'package:app/db/task_group_db_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddGroupPage extends StatefulWidget {
  const AddGroupPage({super.key});

  @override
  State<AddGroupPage> createState() => AddGroupPageState();
}

class AddGroupPageState extends State<AddGroupPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int _characterCount1 = 0;
  int _characterCount2 = 0;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appString = AppString(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 32, left: 12, right: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(LucideIcons.chevron_left),
                    onPressed: () => Navigator.pop(context, true),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final title = _titleController.text.trim();
                      final description = _descriptionController.text.trim();

                      if (title.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(appString.emptyTitleNotifier)),
                        );
                        return;
                      }

                      final newGroup = TaskGroup(
                        name: title,
                        description: description,
                        createdAt: DateTime.now().toIso8601String(),
                      );

                      int newGroupId;

                      try {
                        newGroupId = await TaskGroupDBHelper.insertTaskGroup(
                          newGroup,
                        );
                      } catch (e) {
                        Fluttertoast.showToast(
                          msg: appString.uniqueTitleNotifier,
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.TOP,
                          backgroundColor: Color(0xFFFF5454),
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        return;
                      }

                      if (newGroupId != 0) {
                        final TaskGroup? newlyCreatedGroup =
                            await TaskGroupDBHelper.getTaskGroupById(
                              newGroupId,
                            );

                        if (newlyCreatedGroup != null) {
                          if (mounted) {
                            Navigator.pop(context, newlyCreatedGroup);
                          }
                        } else {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Error: Could not retrieve the created group.",
                                ),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        }
                      } else {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Failed to save the group."),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      }
                      //await TaskGroupDBHelper.insertTaskGroup(newGroup);
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7E1AD1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      minimumSize: const Size(120, 30),
                    ),
                    child: Text(
                      appString.save,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        top: 44.0,
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: _titleController,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\n')),
                              LengthLimitingTextInputFormatter(30),
                            ],
                            textAlign: TextAlign.center,
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: appString.taskGroupTitle,
                              hintStyle: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                              border: InputBorder.none,
                            ),
                            onChanged: (text) {
                              setState(() {
                                _characterCount1 = text.length;
                              });
                            },
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                '$_characterCount1/30',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.only(left: 24, right: 24),
                      child: Divider(color: Color(0xFF7E1AD1), thickness: 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Column(
                        children: [
                          Scrollbar(
                            controller: _scrollController,
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              child: TextField(
                                controller: _descriptionController,
                                maxLines: 4,
                                keyboardType: TextInputType.multiline,
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(
                                    RegExp(r'\n'),
                                  ),
                                  LengthLimitingTextInputFormatter(100),
                                ],
                                onChanged: (text) {
                                  setState(() {
                                    _characterCount2 = text.length;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: appString.descriptionHint,
                                  hintStyle: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                  border: InputBorder.none,
                                ),
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                '$_characterCount2/100',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
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
            ),
          ],
        ),
      ),
    );
  }
}
