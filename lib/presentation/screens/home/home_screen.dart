import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/core/router/app_router.dart';
import 'package:todo_app/domain/entities/task.dart';
import 'package:todo_app/domain/entities/task_filter.dart';
import 'package:todo_app/presentation/cubit/task_cubit/task_cubit.dart';
import 'package:todo_app/presentation/cubit/theme_cubit/theme_cubit.dart';
import 'package:todo_app/presentation/widgets/app_button.dart';
import 'package:todo_app/presentation/widgets/bottom_sheets/edit_task_sheet.dart';
import 'package:todo_app/presentation/widgets/bottom_sheets/view_task_sheet.dart';
import 'package:todo_app/presentation/widgets/checklist_item_tile.dart';
import 'package:todo_app/presentation/widgets/task_filter_chips.dart';



@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Widget _buildFilterChips(TaskFilter currentFilter) => TaskFilterChips(
    current: currentFilter,
    onChanged: (f) => context.read<TaskCubit>().setFilter(f),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SizedBox(
            width: double.infinity,
            child: AppButton.primary(
              onPressed: () => context.pushRoute(const ReportRoute()),
              child: const Text('View Report'),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('Daily Checklist'),
        actions: [
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, mode) {
              final isDark = mode == ThemeMode.dark;
              return IconButton(
                tooltip: isDark
                    ? 'Switch to light mode'
                    : 'Switch to dark mode',
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                onPressed: () => context.read<ThemeCubit>().toggle(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.assignment_turned_in_outlined),
            onPressed: () => context.pushRoute(const ReportRoute()),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: _SearchBox(
              onQueryChanged: (v) =>
                  context.read<TaskCubit>().setQuery(v),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: BlocBuilder<TaskCubit, List<Task>>(
              builder: (context, tasks) {
                final filter = context.read<TaskCubit>().currentFilter;
                return _buildFilterChips(filter);
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<TaskCubit, List<Task>>(
              builder: (context, tasks) {
                if (tasks.isEmpty) {
                  return const Center(child: Text('No tasks. Tap + to add.'));
                }
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    final tile = ChecklistItemTile(
                      task: task,
                      onChanged: (_) {
                        if (task.isCompleted || task.isCompleting) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Task ${task.title} is already completed. Tap to view.'),
                            ),
                          );
                          return;
                        }
                        context
                          .read<TaskCubit>()
                          .completeTaskAfterDelay(task.id);

                          
                      },
                      onTap: () => _showViewSheet(context, task),
                    );

                    if (task.isCompleted) {
                      return tile;
                    }

                    return Dismissible(
                      key: ValueKey(task.id),
                      background: Container(
                        color: Colors.redAccent,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 24),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      secondaryBackground: Container(
                        color: Colors.redAccent,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 24),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) =>
                          context.read<TaskCubit>().removeTask(task.id),
                      child: tile,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushRoute(const AddTaskRoute()),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showEditSheet(BuildContext context, Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => EditTaskSheet(
        task: task,
        onSave: (updated) => context.read<TaskCubit>().updateTask(updated),
      ),
    );
  }

  void _showViewSheet(BuildContext context, Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ViewTaskSheet(
        task: task,
        onEdit: () {
          Navigator.of(context).pop();
          _showEditSheet(context, task);
        },
      ),
    );
  }
}

class _SearchBox extends StatefulWidget {
  const _SearchBox({required this.onQueryChanged});
  final ValueChanged<String> onQueryChanged;

  @override
  State<_SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<_SearchBox> {

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        hintText: 'Search tasks',
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: widget.onQueryChanged,
    );
  }
}
