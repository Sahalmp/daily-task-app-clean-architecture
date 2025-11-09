import 'package:flutter/material.dart';
import 'package:todo_app/domain/entities/task.dart';
import 'package:todo_app/core/theme/app_theme.dart';

class ViewTaskSheet extends StatelessWidget {
  final Task task;
  final VoidCallback? onEdit;

  const ViewTaskSheet({super.key, required this.task, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Task Details', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Title'),
              subtitle: Text(task.title),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Description'),
              subtitle: Text(task.description.isEmpty ? '-' : task.description),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Priority'),
              subtitle: Text(task.priority.label),
              trailing: CircleAvatar(backgroundColor: task.priority.color, radius: 8),
            ),
            if (onEdit != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onEdit,
                      child: const Text('Edit'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}