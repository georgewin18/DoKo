class Task {
  final int? id;
  final String task_name;
  final String? task_desc;
  final String task_reminder;
  final String date;
  final String time;
  final int progress;
  final int task_group_id;

  Task({
    this.id,
    required this.task_name,
    this.task_desc,
    required this.task_reminder,
    required this.date,
    required this.time,
    required this.task_group_id,
    this.progress = 0,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      task_name: map['task_name'],
      task_desc: map['task_desc'],
      task_reminder: map['task_reminder'],
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      progress: map['progress'] ?? 0,
      task_group_id: map['task_group_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task_name': task_name,
      'task_desc': task_desc,
      'task_reminder': task_reminder,
      'date': date,
      'time': time,
      'progress': progress,
      'task_group_id': task_group_id,
    };
  }
}
