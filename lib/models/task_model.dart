class Task {
  final int? id;
  final String task_name;
  final String? task_desc;
  final String? task_attachment;
  final String date;
  final String time;
  final int progress;
  final int task_group_id;
  final String? link;

  Task({
    this.id,
    required this.task_name,
    this.task_desc,
    this.task_attachment,
    required this.date,
    required this.time,
    required this.task_group_id,
    this.progress = 0,
    this.link,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      task_name: map['task_name'],
      task_desc: map['task_desc'],
      task_attachment: map['task_attachment'],
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
      'task_attachment': task_attachment,
      'date': date,
      'time': time,
      'progress': progress,
      'task_group_id': task_group_id,
    };
  }
}
