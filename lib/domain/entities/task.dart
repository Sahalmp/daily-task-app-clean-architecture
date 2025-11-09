import '../../core/theme/app_theme.dart';

class Task {
  final String id;
  String title;
  String description;
  Priority priority;
  DateTime? completedAt;
  bool isCompleting;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    this.completedAt,
    this.isCompleting = false,
    this.isCompleted = false,
  });


  Task copyWith({
    String? id,
    String? title,
    String? description,
    Priority? priority,
    DateTime? completedAt,
    bool? isCompleting,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      completedAt: completedAt ?? this.completedAt,
      isCompleting: isCompleting ?? this.isCompleting,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}