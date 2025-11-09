import 'package:todo_app/domain/entities/task.dart';
import 'package:todo_app/domain/repositories/task_repository.dart';
import 'package:todo_app/domain/entities/task_filter.dart';

class UseCases {
  final TaskRepository taskRepository;

  UseCases(this.taskRepository);

  void addTask(Task task) => taskRepository.addTask(task);

  void deleteTask(String id) => taskRepository.deleteTask(id);

  void markTaskAsCompleting(String id) =>
      taskRepository.markTaskAsCompleting(id);

  void completeTask(String id, DateTime completedAt) =>
      taskRepository.completeTask(id, completedAt);
  void editTask(Task task) => taskRepository.editTask(task);
  void clearCompletedTasks() => taskRepository.clearCompletedTasks();

  Task? getTaskById(String id) => taskRepository.getById(id);
  List<Task> getTasks(TaskFilter filter) => taskRepository.getTasks(filter);
}
