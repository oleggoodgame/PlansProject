import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plans/data/task.dart';

enum TaskListFilter { all, active, completed, time }

final taskListFilter = StateProvider((_) => TaskListFilter.all);

final filteredTodos = Provider<List<Task>>((ref) {
  final filter = ref.watch(taskListFilter);
  final todos = ref.watch(taskProvider);

  switch (filter) {
    case TaskListFilter.completed:
      return todos.where((task) => task.done).toList();
    case TaskListFilter.active:
      return todos.where((task) => !task.done).toList();
    case TaskListFilter.time:
      final sorted = [...todos]; 
      sorted.sort((a, b) {
        final aParts = a.time.split(":");
        final bParts = b.time.split(":");

        final aTotalMinutes = int.parse(aParts[0]) * 60 + int.parse(aParts[1]);
        final bTotalMinutes = int.parse(bParts[0]) * 60 + int.parse(bParts[1]);

        return aTotalMinutes.compareTo(bTotalMinutes);
      });
      return sorted;

    case TaskListFilter.all:
      return todos;
  }
});

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier()
    : super([Task.positional(0, 'Вивчити Riverpod', '00:00', true)]);
  int _nextId = 1;
  void addTask(Task task) {
    final newTask = Task.positional(_nextId, task.name, task.time, task.done);
    state = [...state, newTask];
    _nextId++;
  }

  void addTasks(List<Task> tasks) {
    state = [...state, ...tasks];
  }

  void toggleTask(int id) {
    state = [
      for (final task in state)
        if (task.id == id) task.copyWith(done: !task.done) else task,
    ];
  }

  void deleteTask(Task task) {
    state = state.where((t) => t != task).toList();
  }

  int uncompletedCount() {
    int counter = 0;
    for (Task i in state) {
      if (i.done == false) {
        counter++;
      }
    }
    return counter;
  }

  List<Task> all() {
    return state;
  }
}

final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier();
});
