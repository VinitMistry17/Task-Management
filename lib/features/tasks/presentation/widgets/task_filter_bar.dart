import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/features/tasks/presentation/providers/task_providers.dart';

import '../../data/task_model.dart';

class TaskFilterBar extends ConsumerWidget {
  const TaskFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(taskFilterProvider);
    final notifier = ref.read(taskFilterProvider.notifier);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Priority filter
          // Priority filter
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                label: const Text('All'),
                selected: filter.priority == null,
                onSelected: (_) => notifier.setPriority(null),
              ),
              for (final p in Priority.values)
                ChoiceChip(
                  label: Text(p.label),
                  selected: filter.priority == p,
                  onSelected: (_) => notifier.setPriority(p),
                ),
            ],
          ),
          const SizedBox(height: 8),
          // Status filter
          Text(
            "Status",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          SegmentedButton<StatusFilter>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(value: StatusFilter.all, label: Text('All')),
              ButtonSegment(
                value: StatusFilter.incomplete,
                label: Text('Pending'),
              ),
              ButtonSegment(value: StatusFilter.completed, label: Text('Done')),
            ],
            selected: {filter.status},
            onSelectionChanged: (s) => notifier.setStatus(s.first),
          ),
        ],
      ),
    );
  }
}
