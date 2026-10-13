import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/features/tasks/data/task_model.dart';
import 'package:task_manager/features/tasks/data/task_repository.dart';

import '../../../auth/data/auth_repository.dart';

final firestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

// Logged out hai toh null. User badalte hi ye apne aap naya ban jaata hai.
final taskRepositoryProvider = Provider<TaskRepository?>((ref) {
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) return null;
  return TaskRepository(ref.watch(firestoreProvider), uid);
});

// Firestore se saare tasks (due date se sorted)
final tasksProvider = StreamProvider<List<Task>>((ref) {
  final repo = ref.watch(taskRepositoryProvider);
  if (repo == null) return Stream.value(const <Task>[]);
  return repo.watchTasks();
});

// ---- Filter ----

enum StatusFilter { all, completed, incomplete }

class TaskFilter {
  const TaskFilter({this.priority, this.status = StatusFilter.all});

  final Priority? priority; // null = saari priorities
  final StatusFilter status;
}

class TaskFilterNotifier extends Notifier<TaskFilter> {
  @override
  TaskFilter build() => const TaskFilter();

  void setPriority(Priority? priority) {
    state = TaskFilter(priority: priority, status: state.status);
  }

  void setStatus(StatusFilter status) {
    state = TaskFilter(priority: state.priority, status: status);
  }

  void reset() => state = const TaskFilter();
}

final taskFilterProvider = NotifierProvider<TaskFilterNotifier, TaskFilter>(
  TaskFilterNotifier.new,
);

// UI isi ko watch karegi: tasks + filter dono ka combination
final filteredTasksProvider = Provider<AsyncValue<List<Task>>>((ref) {
  final tasks = ref.watch(tasksProvider);
  final filter = ref.watch(taskFilterProvider);

  return tasks.whenData(
    (list) => list.where((task) {
      final priorityOk =
          filter.priority == null || task.priority == filter.priority;
      final statusOk = switch (filter.status) {
        StatusFilter.all => true,
        StatusFilter.completed => task.isCompleted,
        StatusFilter.incomplete => !task.isCompleted,
      };
      return priorityOk && statusOk;
    }).toList(),
  );
});