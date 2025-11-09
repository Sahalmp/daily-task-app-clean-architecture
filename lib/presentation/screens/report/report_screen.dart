import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/core/router/app_router.dart';
import 'package:todo_app/domain/entities/task.dart';

import '../../cubit/report_cubit/report_cubit.dart';
import '../../widgets/completed_task_card.dart';
import '../../widgets/completion_chart.dart';
import '../../widgets/app_button.dart';

@RoutePage()
class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ReportCubit>().reload();
    return Scaffold(
      appBar: AppBar(title: const Text('Completion Report')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: BlocBuilder<ReportCubit, List<Task>>(
              builder: (context, completedTasks) {
                final now = DateTime.now();
                bool isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;
                final todayCount = completedTasks.where((t) {
                  final dt = t.completedAt;
                  return dt != null && isSameDay(dt, now);
                }).length;
                return Text(
                  '$todayCount task${todayCount == 1 ? '' : 's'} done today',
                  style: Theme.of(context).textTheme.titleMedium,
                );
              },
            ),
          ),
          BlocBuilder<ReportCubit, List<Task>>(
            builder: (context, completedTasks) {
              return CompletionChart(completedTasks: completedTasks, days: 7);
            },
          ),
          Expanded(
            child: BlocBuilder<ReportCubit, List<Task>>(
              builder: (context, completedTasks) {
                if (completedTasks.isEmpty) {
                  return const Center(child: Text('No completed tasks yet.'));
                }
                return ListView.builder(
                  itemCount: completedTasks.length,
                  itemBuilder: (context, index) {
                    final t = completedTasks[index];
                    return CompletedTaskCard(task: t);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  AppButton.outlined(
                    onPressed: () => context.read<ReportCubit>().clearAll(),
                    child: const Text('Clear completed'),
                  ),
                  const SizedBox(height: 8),
                  AppButton.primary(
                    onPressed: () => context.replaceRoute(const HomeRoute()),
                    child: const Text('Back to Checklist'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}