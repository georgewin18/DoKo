import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditTaskBottomSheet extends StatefulWidget {
  const EditTaskBottomSheet({super.key});

  @override
  State<EditTaskBottomSheet> createState() => _EditTaskBottomSheetState();
}

class _EditTaskBottomSheetState extends State<EditTaskBottomSheet> {
  double _progressValue = 0.35;
  List<String> _selectedReminders = ['1 day before'];
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _attachmentController = TextEditingController();

  void _showReminderOptions() {
    final options = ['1 day before', '2 days before', '3 days before'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        List<String> tempSelected = List.from(_selectedReminders);
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
                    final isSelected = tempSelected.contains(option);
                    return CheckboxListTile(
                      title: Text(option),
                      value: isSelected,
                      onChanged: (checked) {
                        setModalState(() {
                          if (checked == true &&
                              !tempSelected.contains(option)) {
                            tempSelected.add(option);
                          } else {
                            tempSelected.remove(option);
                          }
                        });
                      },
                    );
                  }).toList(),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedReminders = tempSelected;
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  String getFormattedDateTime() {
    if (_selectedDate == null || _selectedTime == null) {
      return 'EEE, dd MMM yyyy';
    }
    final date = DateFormat('EEE, dd MMM yyyy').format(_selectedDate!);
    final time =
        '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}';
    return '$date $time';
  }

  @override
  Widget build(BuildContext context) {
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
            //judul task yg diedit
            const Text(
              'PPT Fuzzy Logic',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              onTap: _showReminderOptions,
              leading: const Icon(Icons.alarm),
              title: const Text('Reminder'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_selectedReminders.join(', ')),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Deadline'),
              onTap: () async {
                await _selectDate(context);
                await _selectTime(context);
              },
              trailing: Text(getFormattedDateTime()),
            ),
            ListTile(
              leading: const Icon(Icons.note),
              title: TextField(
                controller: _notesController,
                decoration: const InputDecoration(
                  hintText: 'Add Notes...',
                  border: InputBorder.none,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.attach_file),
              title: TextField(
                controller: _attachmentController,
                decoration: const InputDecoration(
                  hintText: 'Add Attachment...',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Progress Section
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
              ), // Sama rata dengan Add Attachment
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.show_chart, color: Colors.grey),
                      const SizedBox(width: 8),
                      const Text(
                        'Progress',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Colors.green,
                            inactiveTrackColor: Colors.green.withOpacity(0.2),
                            thumbColor: Colors.green,
                            trackHeight: 4,
                          ),
                          child: Slider(
                            value: _progressValue,
                            min: 0,
                            max: 1,
                            divisions: 20,
                            onChanged: (value) {
                              setState(() {
                                _progressValue = value;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${(_progressValue * 100).round()}%',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Discard',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 126, 26, 209),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
