import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/domain/entities/task.dart';
import 'package:todo_app/domain/usecases/usecases.dart';
import 'package:todo_app/domain/entities/task_filter.dart';


class ReportCubit extends Cubit<List<Task>> {
  final UseCases useCases;
  ReportCubit(this.useCases) : super(const []);

  void reload() {
    emit(
      useCases.getTasks(TaskFilter.completed),
    );
  }

  void clearAll() {
    useCases.clearCompletedTasks();
    reload();
  }
}
