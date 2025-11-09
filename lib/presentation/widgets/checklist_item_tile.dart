import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/entities/task.dart';

class ChecklistItemTile extends StatelessWidget {
  final Task task;
  final ValueChanged<bool?>? onChanged;
  final VoidCallback? onTap;

  const ChecklistItemTile({
    super.key,
    required this.task,
    this.onChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
   
    return ListTile(
      leading: Checkbox(
        value: task.isCompleted || task.isCompleting,
        onChanged: onChanged,
        
      ),
      title: Text(
        task.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: task.isCompleted
            ? Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: cs.secondary)
            : Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        task.description,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: _PriorityTag(priority: task.priority),
      onTap: onTap,
    );
  }
}

class _PriorityTag extends StatelessWidget {
  final Priority priority;
  const _PriorityTag({required this.priority});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: priority.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: priority.color.withValues(alpha: 0.6)),
      ),
      child: Text(
        priority.label,
        style: TextStyle(color: priority.color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
