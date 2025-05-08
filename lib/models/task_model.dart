class Task {
  final int? id;
  final String taskName;
  final String? taskDesc;
  final String? taskAttachment;
  final String date;
  final String time;
  final int progress;
  final int taskGroupId;

  Task({
    this.id,
    required this.taskName,
    this.taskDesc,
    this.taskAttachment,
    required this.date,
    required this.time,
    required this.taskGroupId,
    this.progress = 0,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      taskName: map['taskName'],
      taskDesc: map['taskDesc'],
      taskAttachment: map['taskAttachment'],
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      progress: map['progress'] ?? 0,
      taskGroupId: map['taskGroupId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskName': taskName,
      'taskDesc': taskDesc,
      'taskAttachment': taskAttachment,
      'date': date,
      'time': time,
      'progress': progress,
      'taskGroupId': taskGroupId,
    };
  }
}
