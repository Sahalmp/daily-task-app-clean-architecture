import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/domain/usecases/usecases.dart';

import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/task.dart';
import '../../../domain/entities/task_filter.dart';

import '../report_cubit/report_cubit.dart';
class TaskCubit extends Cubit<List<Task>> {
  final UseCases useCases;
  final ReportCubit reportCubit;

  TaskFilter _currentFilter = TaskFilter.pending;
  TaskFilter get currentFilter => _currentFilter;
  String _query = '';
  String get query => _query;

  TaskCubit({
    required this.useCases,
    required this.reportCubit,
  }) : super(const []);

  void loadTasks() {
    final tasks = _filteredTasks(_currentFilter, _query);
    emit(tasks);
  }

  void setFilter(TaskFilter filter) {
    _currentFilter = filter;
    emit(_filteredTasks(filter, _query));
  }

  void setQuery(String query) {
    _query = query.trim().toLowerCase();
    emit(_filteredTasks(_currentFilter, _query));
  }

  void addNewTask({
    required String title,
    required String description,
    required Priority priority,
  }) {
    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      priority: priority,
    );
    useCases.addTask(task);
    loadTasks();
  }

  void updateTask(Task task) {
    useCases.editTask(task);
    loadTasks();
  }

  void removeTask(String id) {
    useCases.deleteTask(id);
    loadTasks();
  }

  Future<void> completeTaskAfterDelay(String id) async {
  
    useCases.markTaskAsCompleting(id);
    emit(_filteredTasks(_currentFilter, _query));

    await Future.delayed(const Duration(seconds: 5));
    useCases.completeTask(id, DateTime.now());

    emit(_filteredTasks(_currentFilter, _query));

    reportCubit.reload();
  }

  List<Task> _filteredTasks(TaskFilter filter, String query) {
    var tasks = useCases.getTasks(filter);
    if (query.isNotEmpty) {
      tasks = tasks
          .where((t) => t.title.toLowerCase().contains(query))
          .toList();
    }
    return tasks;
  }
}