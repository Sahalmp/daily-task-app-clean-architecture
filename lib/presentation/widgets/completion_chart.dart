import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/task.dart';

class CompletionChart extends StatelessWidget {
  final List<Task> completedTasks;
  final int days;

  const CompletionChart({
    super.key,
    required this.completedTasks,
    this.days = 7,
  });

  static const double _chartHeight = 160.0;
  static const double _labelAreaHeight = 40.0;
  static const Duration _barAnimationDuration = Duration(milliseconds: 400);
  static const Duration _countFadeDuration = Duration(milliseconds: 200);
  static const double _countTextHeight = 16.0;
  static const double _countTextPadding = 4.0;

  @override
  Widget build(BuildContext context) {
    final effectiveDays = days <= 0 ? 1 : days;

    final now = DateTime.now();
    final todayOnly = DateTime(now.year, now.month, now.day);
    final start = todayOnly.subtract(Duration(days: effectiveDays - 1));

    final counts = _countCompletedTasksByDay(
      completedTasks,
      start,
      todayOnly,
      effectiveDays,
    );
    final labels = _buildDayLabels(start, effectiveDays);
    final hasAnyData = counts.any((c) => c > 0);

    final maxCount = counts.fold<int>(0, (p, c) => c > p ? c : p);

    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final baseBarColor = cs.primary;
    final todayBarColor = cs.tertiary;
    final gridColor = cs.outline.withAlpha(0x25);

    final barMaxHeight = _chartHeight - _labelAreaHeight;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Last $effectiveDays days', style: textTheme.titleSmall),
            const SizedBox(height: 8),

            if (!hasAnyData)
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'No completed tasks in this period yet.',
                  style: textTheme.bodySmall?.copyWith(color: cs.outline),
                ),
              ),

            SizedBox(
              height: _chartHeight,
              child: Stack(
                children: [
                  ..._buildGridLines(gridColor, barMaxHeight),

                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: _labelAreaHeight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(effectiveDays, (i) {
                        final count = counts[i];
                        final hRatio = count / (maxCount > 0 ? maxCount : 1);
                        final currentDay = start.add(Duration(days: i));
                        final isToday = currentDay.isAtSameMomentAs(todayOnly);
                        final barColor = isToday ? todayBarColor : baseBarColor;

                        return Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              AnimatedOpacity(
                                opacity: count > 0 ? 1.0 : 0.0,
                                duration: _countFadeDuration,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text(
                                    '$count',
                                    style: textTheme.bodySmall,
                                  ),
                                ),
                              ),

                              TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0, end: hRatio),
                                duration: _barAnimationDuration,
                                curve: Curves.easeOut,
                                builder: (context, value, child) {
                                  final reservedForCount = count > 0
                                      ? (_countTextHeight + _countTextPadding)
                                      : 0.0;
                                  final barHeight =
                                      (barMaxHeight - reservedForCount) * value;
                                  return Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    height: barHeight,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8),
                                      ),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          barColor.withAlpha(0x85),
                                          barColor,
                                        ],
                                      ),
                                      boxShadow: isToday
                                          ? [
                                              BoxShadow(
                                                color: barColor.withAlpha(0x35),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ]
                                          : null,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),

                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: _labelAreaHeight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(effectiveDays, (i) {
                        return Expanded(
                          child: Center(
                            child: Text(
                              labels[i],
                              style: textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            Wrap(
              children: [
                _LabelItem(color: baseBarColor, label: 'Completed'),
                _LabelItem(color: todayBarColor, label: 'Today'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildGridLines(Color gridColor, double barMaxHeight) {
    return [
      Positioned(
        left: 0,
        right: 0,
        bottom: _labelAreaHeight + barMaxHeight * 0.25,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          height: 1,
          color: gridColor,
        ),
      ),
      Positioned(
        left: 0,
        right: 0,
        bottom: _labelAreaHeight + barMaxHeight * 0.5,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          height: 1,
          color: gridColor,
        ),
      ),
      Positioned(
        left: 0,
        right: 0,
        bottom: _labelAreaHeight + barMaxHeight * 0.75,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          height: 1,
          color: gridColor,
        ),
      ),
      Positioned(
        left: 0,
        right: 0,
        bottom: _labelAreaHeight,
        child: Container(height: 1, color: gridColor),
      ),
    ];
  }

  List<int> _countCompletedTasksByDay(
    List<Task> tasks,
    DateTime start,
    DateTime todayOnly,
    int effectiveDays,
  ) {
    final counts = List<int>.filled(effectiveDays, 0);
    for (final t in tasks) {
      final dt = t.completedAt;
      if (dt == null) continue;
      final dayOnly = DateTime(dt.year, dt.month, dt.day);
      if (dayOnly.isBefore(start) || dayOnly.isAfter(todayOnly)) continue;

      final diff = dayOnly.difference(start).inDays;
      if (diff >= 0 && diff < effectiveDays) counts[diff]++;
    }
    return counts;
  }

  List<String> _buildDayLabels(DateTime start, int effectiveDays) {
    return List<String>.generate(effectiveDays, (i) {
      final d = start.add(Duration(days: i));
      return DateFormat('E').format(d);
    });
  }
}

class _LabelItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LabelItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: textTheme.bodySmall),
      ],
    );
  }
}
