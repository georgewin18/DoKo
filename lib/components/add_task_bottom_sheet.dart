import 'package:doko/db/task_db_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class AddTaskBottomSheet extends StatefulWidget {
  final int? groupId;

  const AddTaskBottomSheet({super.key, required this.groupId});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  // List<String> _selectedReminders = [];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _attachmentController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // memilih tanggal
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked =
        (await showDatePicker(
          context: context,
          initialDate: _selectedDate ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2101),
        ))!;
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // memilih waktu
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        (await showTimePicker(
          context: context,
          initialTime: _selectedTime ?? TimeOfDay.now(),
        ))!;
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // menampilkan tanggal dan waktu
    String getFormattedDateTime() {
      if (_selectedDate == null || _selectedTime == null) {
        return DateFormat('EEE, dd MMM yyyy HH:mm').format(DateTime.now());
      }
      final DateFormat dateFormat = DateFormat('EEE, dd MMM yyyy');
      final String formattedDate = dateFormat.format(_selectedDate!);
      final String formattedTime =
          '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}';
      return '$formattedDate $formattedTime';
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
            //add title
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Add Title...',
                hintStyle: TextStyle(
                  color: Color.fromARGB(255, 169, 169, 169),
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  height: 1.5,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
              ),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              inputFormatters: [LengthLimitingTextInputFormatter(30)],
            ),

            const SizedBox(
                height: 16
            ),

            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Deadline'),
              onTap: () async {
                await _selectDate(context);
                await _selectTime(context);
              },
              trailing: Text(getFormattedDateTime()),
            ),
            //add notes
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
            //add attachment
            ListTile(
              leading: const Icon(Icons.attach_file),
              title: TextField(
                controller: _attachmentController,
                decoration: const InputDecoration(
                  hintText: 'Add your drive link here',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.black),
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
                //data input
                final title = _titleController.text;
                final notes = _notesController.text;
                final attachment = _attachmentController.text;

                if (title.isEmpty || _selectedDate == null || _selectedTime == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please complete all required fields')),
                  );
                  Navigator.pop(context);
                  return;
                }

                final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
                final formattedTime =
                    '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}';

                await TaskDbHelper().addTask(
                    title,
                    notes,
                    attachment,
                    formattedDate,
                    formattedTime,
                    0,
                    widget.groupId
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
