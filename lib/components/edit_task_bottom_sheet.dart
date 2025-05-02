import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'delete_confirmation_dialog.dart';
import '../models/task_model.dart';

class EditTaskBottomSheet extends StatefulWidget {
  final Task task;
  const EditTaskBottomSheet({super.key, required this.task});

  @override
  State<EditTaskBottomSheet> createState() => _EditTaskBottomSheetState();
}

class _EditTaskBottomSheetState extends State<EditTaskBottomSheet> {
  double _progressValue = 0.0;
  String _selectedRepeat = '1 day before';
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _attachmentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedRepeat = widget.task.task_reminder;
    _progressValue = widget.task.progress / 100;

    _notesController.text = widget.task.task_desc ?? '';
    _attachmentController.text = ''; // kosongkan atau sesuaikan

    // parsing tanggal & waktu
    _selectedDate = DateFormat('yyyy-MM-dd').parse(widget.task.date);
    final timeParts = widget.task.time.split(':');
    _selectedTime = TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );
  }

  void _showRepeatOptions() {
    final options = ['1 day before', '2 days before', '3 days before'];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        String tempSelected = _selectedRepeat;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Select Repeat Option',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ...options.map((option) {
                    return RadioListTile<String>(
                      title: Text(option),
                      value: option,
                      groupValue: tempSelected,
                      onChanged: (value) {
                        setModalState(() {
                          tempSelected = value!;
                        });
                      },
                    );
                  }).toList(),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedRepeat = tempSelected;
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
    final picked = await showDatePicker(
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
    final picked = await showTimePicker(
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
      return 'Eee, dd MMM yyyy\nHH:mm AM';
    }
    final date = DateFormat('Eee, dd MMM yyyy').format(_selectedDate!);
    final hour = _selectedTime!.hourOfPeriod.toString().padLeft(2, '0');
    final minute = _selectedTime!.minute.toString().padLeft(2, '0');
    final period = _selectedTime!.period == DayPeriod.am ? 'AM' : 'PM';
    return '$date\n$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  widget.task.task_name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    deleteConfirmationDialog(context, widget.task.task_name);
                  },
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Reminder Header
            const Row(
              children: [
                Icon(Icons.alarm, size: 24),
                SizedBox(width: 8),
                Text(
                  'Reminder',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Repeat
            Padding(
              padding: const EdgeInsets.only(left: 32.0, right: 8), // indent
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Repeat'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_selectedRepeat),
                    const Icon(Icons.chevron_right),
                  ],
                ),
                onTap: _showRepeatOptions,
              ),
            ),

            // Deadline
            Padding(
              padding: const EdgeInsets.only(left: 32.0, right: 8), // indent
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Deadline'),
                trailing: Text(
                  getFormattedDateTime(),
                  textAlign: TextAlign.right,
                  style: const TextStyle(color: Colors.grey),
                ),
                onTap: () async {
                  await _selectDate(context);
                  await _selectTime(context);
                },
              ),
            ),

            // Notes
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.note),
              title: TextField(
                controller: _notesController,
                decoration: const InputDecoration(
                  hintText: 'Add Notes...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),

            // Attachment
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.attach_file),
              title: TextField(
                controller: _attachmentController,
                decoration: const InputDecoration(
                  hintText: 'Add Attachment...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Progress
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
              ],
            ),
            const SizedBox(height: 20),

            // Buttons
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
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Discard',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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
