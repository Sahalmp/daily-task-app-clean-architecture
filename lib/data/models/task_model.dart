import '../../core/theme/app_theme.dart';
import '../../domain/entities/task.dart';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final Priority priority;
  final DateTime? completedAt;
  final bool isCompleting;
  final bool isCompleted;


  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    this.completedAt,
    this.isCompleting =false,
    this.isCompleted = false,
  });

  factory TaskModel.fromEntity(Task task) => TaskModel(
        id: task.id,
        title: task.title,
        description: task.description,
        priority: task.priority,
        completedAt: task.completedAt,
        isCompleting: task.isCompleting,
        isCompleted: task.isCompleted,
      );

  Task toEntity() => Task(
        id: id,
        title: title,
        description: description,
        priority: priority,
        completedAt: completedAt,
        isCompleting: isCompleting,
        isCompleted: isCompleted,
      );
}