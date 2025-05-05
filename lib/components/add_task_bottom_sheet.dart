import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  List<String> _selectedReminders = [];

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
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  // memilih waktu
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        (await showTimePicker(
          context: context,
          initialTime: _selectedTime ?? TimeOfDay.now(),
        ))!;
    if (picked != null && picked != _selectedTime)
      setState(() {
        _selectedTime = picked;
      });
  }

  void _showReminderOptions() {
    final options = [
      '1 day before',
      '2 days before',
      '3 days before',
    ]; //tdk ditampilkan

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        List<String> tempSelectedReminders = List.from(_selectedReminders);

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Select Reminder(s)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ...options.map((option) {
                    final isSelected = tempSelectedReminders.contains(option);
                    return CheckboxListTile(
                      title: Text(option),
                      value: isSelected,
                      onChanged: (bool? checked) {
                        setModalState(() {
                          if (checked == true &&
                              !tempSelectedReminders.contains(option)) {
                            tempSelectedReminders.add(option);
                          } else if (checked == false) {
                            tempSelectedReminders.remove(option);
                          }
                        });
                      },
                    );
                  }).toList(),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedReminders = tempSelectedReminders;
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Done'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // menampilkan tanggal dan waktu
    String getFormattedDateTime() {
      if (_selectedDate == null || _selectedTime == null) {
        return 'Eee, dd MMM yyyy';
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
            ),
            const SizedBox(height: 16),
            //reminder
            ListTile(
              onTap: _showReminderOptions,
              leading: const Icon(Icons.alarm),
              title: const Text('Reminder'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _selectedReminders.isEmpty
                        ? 'No reminder set'
                        : _selectedReminders.join(', '),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color:
                          _selectedReminders.isEmpty
                              ? Colors.grey
                              : Colors.black,
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
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
              ),
            ),
            //add attachment
            ListTile(
              leading: const Icon(Icons.attach_file),
              title: TextField(
                controller: _attachmentController,
                decoration: const InputDecoration(
                  hintText: 'Add Your Link',
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
              onPressed: () {
                //data input
                final title = _titleController.text;
                final notes = _notesController.text;
                final attachment = _attachmentController.text;

                Navigator.pop(context);
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
