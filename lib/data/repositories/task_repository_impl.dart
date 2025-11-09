
import 'package:todo_app/domain/entities/task_filter.dart';

import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final List<Task> tasks = [];

  @override
  void addTask(Task task) {
    tasks.add(task);
  }

  @override
  Task completeTask(String id, DateTime completedAt) {
    final index = tasks.indexWhere((t) => t.id == id);
    if (index == -1) throw Exception('Task not found');

    

    final completedTask = tasks[index].copyWith(
      completedAt: completedAt,
      isCompleted: true,
    );
    tasks[index] = completedTask;
    return completedTask;
  }
  @override
  void deleteTask(String id) {
    tasks.removeWhere((t) => t.id == id);
  }

  @override
  void editTask(Task task) {

    final idx = tasks.indexWhere((t) => t.id == task.id);
    if (idx != -1) {
      tasks[idx] = task;
    }
  }

  @override
  Task? getById(String id) {
    try {
      return tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  List<Task> getTasks(TaskFilter filter) {
    switch (filter) {
      case TaskFilter.all:
        return List.from(tasks);
      case TaskFilter.pending:
        return List.from(tasks.where((t) => !t.isCompleted));
      case TaskFilter.completed:
        return List.from(tasks.where((t) => t.isCompleted));
    }
  }

  @override
  void clearCompletedTasks() {
    tasks.removeWhere((t) => t.isCompleted);
  }

  @override
  Task markTaskAsCompleting(String id) {
    final index = tasks.indexWhere((t) => t.id == id);
    if (index == -1) throw Exception('Task not found');
    final completingTask = tasks[index].copyWith(
      isCompleting: true,
    );
    tasks[index] = completingTask;
    return completingTask;
  }
}