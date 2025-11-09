import 'package:flutter/material.dart';
import 'package:todo_app/domain/entities/task_filter.dart';

class TaskFilterChips extends StatelessWidget {
  final TaskFilter current;
  final ValueChanged<TaskFilter> onChanged;

  const TaskFilterChips({
    super.key,
    required this.current,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        ChoiceChip(
          label: const Text('All'),
          selected: current == TaskFilter.all,
          onSelected: (_) => onChanged(TaskFilter.all),
        ),
        ChoiceChip(
          label: const Text('Pending'),
          selected: current == TaskFilter.pending,
          onSelected: (_) => onChanged(TaskFilter.pending),
        ),
        ChoiceChip(
          label: const Text('Completed'),
          selected: current == TaskFilter.completed,
          onSelected: (_) => onChanged(TaskFilter.completed),
        ),
      ],
    );
  }
}