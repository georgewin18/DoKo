import 'package:app/db/task_db_helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class AddTaskModal extends StatefulWidget {
  final int? groupId;
  final String selectedDateOnCalendar;

  const AddTaskModal({
    super.key,
    required this.groupId,
    required this.selectedDateOnCalendar,
  });

  @override
  State<AddTaskModal> createState() => _AddTaskModalState();
}

class _AddTaskModalState extends State<AddTaskModal> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _attachmentController = TextEditingController();

  late TimeOfDay selectedTime;
  late DateTime parsedDate;
  late String formattedDate;

  bool isValidDriveLink = true;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        (await showTimePicker(context: context, initialTime: selectedTime))!;
    if (picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    parsedDate = DateTime.parse(widget.selectedDateOnCalendar);
    formattedDate = DateFormat('EEE, dd MMM yyyy').format(parsedDate);
    selectedTime = TimeOfDay(hour: 23, minute: 59);
  }

  @override
  Widget build(BuildContext context) {
    String getFormattedTime(TimeOfDay time) {
      final hour = time.hour.toString().padLeft(2, '0');
      final minute = time.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Add Title... (required)',
                hintStyle: TextStyle(
                  color: Color.fromARGB(255, 169, 169, 169),
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
              ),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              inputFormatters: [LengthLimitingTextInputFormatter(30)],
            ),

            const SizedBox(height: 16),

            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Deadline'),
            ),

            Container(
              padding: EdgeInsets.only(left: 42),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(title: Text('Date'), trailing: Text(formattedDate)),

                  ListTile(
                    title: Text('Time'),
                    onTap: () async {
                      await _selectTime(context);
                    },
                    trailing: Text(getFormattedTime(selectedTime)),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.note),
              title: TextField(
                controller: _notesController,
                decoration: const InputDecoration(
                  hintText: 'Add Notes...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.black),
                inputFormatters: [LengthLimitingTextInputFormatter(100)],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.attach_file),
              title: TextField(
                controller: _attachmentController,
                onChanged: (value) {
                  final regex = RegExp(
                    r'^(https?:\/\/)?([\w\-]+\.)*[\w\-]+\.com(\/.*)?$',
                    caseSensitive: false,
                  );
                  setState(() {
                    isValidDriveLink = value.isEmpty || regex.hasMatch(value);
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Add your drive link here',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  color: isValidDriveLink ? Colors.blue : Colors.red,
                  decoration:
                      isValidDriveLink
                          ? TextDecoration.underline
                          : TextDecoration.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 126, 26, 209),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () async {
                final title = _titleController.text;
                final notes = _notesController.text;
                final attachment = _attachmentController.text;

                final driveLinkRegex = RegExp(
                  r'^(https?:\/\/)?([\w\-]+\.)+com(\/.*)?$',
                  caseSensitive: false,
                );

                if (title.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Title can't be empty!",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.TOP,
                    backgroundColor: Color(0xFFFF5454),
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  return;
                }

                if (attachment.isNotEmpty && !driveLinkRegex.hasMatch(attachment)) {
                  Fluttertoast.showToast(
                    msg: "Invalid Google Drive link!",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.TOP,
                    backgroundColor: Color(0xFFFF5454),
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  return;
                }

                final deadlineDate = DateFormat(
                  'yyyy-MM-dd',
                ).format(parsedDate);
                final deadlineTime =
                    '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';

                await TaskDbHelper().addTask(
                  title,
                  notes,
                  attachment,
                  deadlineDate,
                  deadlineTime,
                  0,
                  widget.groupId,
                );

                Navigator.pop(context, true);
              },
              child: const Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
