import 'package:todo_app/domain/entities/task_filter.dart';

import '../entities/task.dart';

abstract class TaskRepository {
  List<Task> getTasks(TaskFilter filter);
  void clearCompletedTasks();

  void addTask(Task task);
  void editTask(Task task);
  void deleteTask(String id);
  Task? getById(String id);
  Task completeTask(String id, DateTime completedAt);
  Task markTaskAsCompleting(String id);
}