import 'package:app/db/task_db_helper.dart';
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
  // String _selectedRepeat = '1 day before';
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int? taskId;

  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _attachmentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    taskId = widget.task.id;

    _progressValue = widget.task.progress / 100;

    _notesController.text = widget.task.task_desc ?? '';
    _attachmentController.text =
        widget.task.task_attachment ?? ''; // kosongkan atau sesuaikan

    // parsing tanggal & waktu
    _selectedDate = DateFormat('yyyy-MM-dd').parse(widget.task.date);
    final timeParts = widget.task.time.split(':');
    _selectedTime = TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
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
      return 'EEE, dd MMM yyyy\nHH:mm AM';
    }
    final date = DateFormat('EEE, dd MMM yyyy').format(_selectedDate!);
    final hour = _selectedTime!.hourOfPeriod.toString().padLeft(2, '0');
    final minute = _selectedTime!.minute.toString().padLeft(2, '0');
    final period = _selectedTime!.period == DayPeriod.am ? 'AM' : 'PM';
    return '$date\n$hour:$minute $period';
  }

  Future<bool> saveTaskUpdate() async {
    try {
      final updatedTaskName = widget.task.task_name;
      final updatedTaskDesc = _notesController.text;
      final updatedAttachment = _attachmentController.text;
      final updatedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      final parsedTime = TimeOfDay(
        hour: _selectedTime!.hour,
        minute: _selectedTime!.minute,
      );

      final hour = parsedTime.hour.toString().padLeft(2, '0');
      final minute = parsedTime.minute.toString().padLeft(2, '0');
      final time24H = '$hour:$minute';

      final progressPercent = (_progressValue * 100).round();

      await TaskDbHelper().updateTask(
        taskId,
        updatedTaskName,
        updatedTaskDesc,
        updatedAttachment,
        updatedDate,
        time24H,
        progressPercent,
      );

      return true;
    } catch (e) {
      debugPrint("Error update task: $e");
      return false;
    }
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
                Text(
                  widget.task.task_name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () async {
                    final confirmed = await deleteTaskConfirmationDialog(
                      context,
                      widget.task,
                    );

                    if (confirmed) {
                      await TaskDbHelper().deleteTask(widget.task.id);
                      Navigator.of(context).pop({'action': 'delete'});
                    }
                  },
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                ),
              ],
            ),

            const SizedBox(height: 12),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.calendar_today),
              title: Text('Deadline'),
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
                  hintText: 'Add your drive link here',
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
                      inactiveTrackColor: Colors.green.withAlpha(51),
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
                    onPressed: () async {
                      if (_selectedDate != null && _selectedTime != null) {
                        final success = await saveTaskUpdate();
                        if (success) {
                          Navigator.of(context).pop({'action': 'update'});
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Gagal memperbarui task")),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please select a deadline')),
                        );
                      }
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
