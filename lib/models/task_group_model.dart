class TaskGroup {
  final int? id;
  final String name;
  final String? description;
  final String createdAt;
  final int notStartedCount;
  final int ongoingCount;
  final int completedCount;

  TaskGroup({
    this.id,
    required this.name,
    this.description,
    required this.createdAt,
    this.notStartedCount = 0,
    this.ongoingCount = 0,
    this.completedCount = 0,
  });

  factory TaskGroup.fromMap(Map<String, dynamic> map) {
    return TaskGroup(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      createdAt: map['created_at'],
      notStartedCount: map['not_started_count'] ?? 0,
      ongoingCount: map['ongoing_count'] ?? 0,
      completedCount: map['completed_count'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_at': createdAt,
      'not_started_count': notStartedCount,
      'ongoing_count': ongoingCount,
      'completed_count': completedCount,
    };
  }
}