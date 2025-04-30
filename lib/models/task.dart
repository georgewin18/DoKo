import 'package:flutter/material.dart';

class Task {
  String title;
  DateTime date; // tanggal
  TimeOfDay? startTime; // Start time opsional buat event
  TimeOfDay? endTime; // End time opsional buat event
  DateTime? endDate; // End date untuk tenggat
  bool isEvent; // true = event, false = task,
  // TaskPriority priority;
  // TaskStatus status; //isinya warna jadi nanti ada pengecekannya
  bool
  isCompleted; // warna hijau dan nanti akan ada pembatas untuk tugas yang sudah selesai.

  Task({
    required this.title,
    required this.date,
    this.startTime,
    this.endTime,
    this.endDate,
    required this.isEvent,
    // this.priority = TaskPriority.normal,
    // this.status = TaskStatus.notStarted,
    this.isCompleted = false,
  });

  // TaskStatus calculateStatus(DateTime now) {
  //   if (isEvent) return TaskStatus.event;
  //   if (isCompleted) return TaskStatus.completed;
  //   if (priority == TaskPriority.priority) return TaskStatus.priority;

  //   final taskDateTime = DateTime(
  //     date.year,
  //     date.month,
  //     date.day,
  //     endTime?.hour ?? 23,
  //     endTime?.minute ?? 59,
  //   );

  //   if (now.isAfter(taskDateTime)) return TaskStatus.overdue;

  //   final isSameDay =
  //       now.year == date.year && now.month == date.month && now.day == date.day;

  //   if (isSameDay) return TaskStatus.dueToday;

  //   return TaskStatus.notStarted;
  // }
  // Color getStatusColor() {
  //   switch (status) {
  //     case TaskStatus.overdue:
  //       return statusColor[0];
  //     case TaskStatus.ongoing:
  //       return statusColor[1];
  //     case TaskStatus.notStarted:
  //       return statusColor[2];
  //     case TaskStatus.dueToday:
  //       return statusColor[3];
  //     case TaskStatus.completed:
  //       return statusColor[4];
  //     case TaskStatus.event:
  //       return statusColor[5];
  //     case TaskStatus.priority:
  //       return statusColor[6];
  //   }
  // }

  // // Update status based on current time
  // void updateStatus() {
  //   if (!isEvent) {
  //     status = calculateStatus(DateTime.now());
  //   }
  // }
}
