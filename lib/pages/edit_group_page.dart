import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter/services.dart';
import 'package:app/models/task_group_model.dart';
import 'package:app/db/task_group_db_helper.dart';

class EditGroupPage extends StatefulWidget {
  final TaskGroup group;

  const EditGroupPage({super.key, required this.group});

  @override
  State<EditGroupPage> createState() => EditGroupPageState();
}

class EditGroupPageState extends State<EditGroupPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  int _characterCount = 0;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.group.name);
    _descriptionController = TextEditingController(
      text: widget.group.description ?? '',
    );
    _characterCount = _descriptionController.text.length;
    _titleController.addListener(_validateInput);
    _descriptionController.addListener(_validateInput);
  }

  void _validateInput() {
    final trimmedTitle = _titleController.text.trim();
    setState(() {
      _isSaveEnabled = trimmedTitle.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    TaskGroup updatedGroup = TaskGroup(
      id: widget.group.id,
      name: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      createdAt: DateTime.now().toIso8601String(),
    );
    await TaskGroupDBHelper.updateTaskGroup(updatedGroup);
  }

  bool _isSaveEnabled = false;

  @override
  Widget build(BuildContext context) {
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
                    onPressed: () => Navigator.pop(context),
                  ),
                  ElevatedButton(
                    onPressed:
                        _isSaveEnabled
                            ? () {
                              _saveChanges();
                              Navigator.pop(context, true);
                            }
                            : null, // tombol nonaktif
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isSaveEnabled
                              ? const Color(0xFF7E1AD1)
                              : Colors.grey,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      minimumSize: const Size(120, 30),
                    ),
                    child: const Text(
                      'Save',
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
                      padding: const EdgeInsets.only(top: 44.0),
                      child: TextField(
                        controller: _titleController,
                        inputFormatters: [LengthLimitingTextInputFormatter(30)],
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          hintText: 'Group Title',
                          hintStyle: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 12, left: 24, right: 24),
                      child: Divider(color: Color(0xFF7E1AD1), thickness: 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: _descriptionController,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(100),
                            ],
                            onChanged: (text) {
                              setState(() {
                                _characterCount = text.length;
                              });
                            },
                            decoration: const InputDecoration(
                              hintText: 'Description.....',
                              hintStyle: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(fontSize: 18),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                '$_characterCount/100',
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
