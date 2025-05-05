import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter/services.dart';
import 'package:doko/models/task_group_model.dart';
import 'package:doko/db/task_group_db_helper.dart';

class AddGroupPage extends StatefulWidget {
  const AddGroupPage({super.key});

  @override
  State<AddGroupPage> createState() => AddGroupPageState();
}

class AddGroupPageState extends State<AddGroupPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int _characterCount = 0;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

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
                    onPressed: () => Navigator.pop(context, true),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final title = _titleController.text.trim();
                      final description = _descriptionController.text.trim();
                      Navigator.pop(context, true);
                      
                      if (title.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Judul tidak boleh kosong"),
                          ),
                        );
                        return;
                      }

                      final newGroup = TaskGroup(
                        name: title,
                        description: description,
                        createdAt: DateTime.now().toIso8601String(),
                      );

                      await TaskGroupDBHelper.insertTaskGroup(newGroup);
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7E1AD1),
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
                    Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 200,
                            height: 200,
                            margin: const EdgeInsets.only(top: 28),
                            decoration: BoxDecoration(
                              color: const Color(0xFFCFB1E7),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          Positioned(
                            right: -10,
                            bottom: -10,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Color(0xFF7E1AD1),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  LucideIcons.pencil,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                onPressed: () {
                                  // Tombol edit gambar
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                          Scrollbar(
                            controller: _scrollController,
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              child: TextField(
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
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                '$_characterCount/200',
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
