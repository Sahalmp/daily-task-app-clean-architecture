import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/task.dart';

class CompletedTaskCard extends StatelessWidget {
  final Task task;
  const CompletedTaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final dt = task.completedAt ?? DateTime.now();
    final formatted = DateFormat('d MMM yyyy, h:mm a').format(dt);
    final cs = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.check_circle, color: cs.secondary, size: 26),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: cs.secondary)),
                  const SizedBox(height: 4),
                  Text(formatted, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}