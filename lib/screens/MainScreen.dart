import 'package:flutter/material.dart';
import 'package:plans/provider/TaskProvider.dart';
import 'package:plans/screens/NewTask.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plans/widgets/DataTableWidget.dart';

class TasksTable extends ConsumerStatefulWidget {
  const TasksTable({super.key});

  @override
  ConsumerState<TasksTable> createState() {
    return _TasksTableState();
  }
}

class _TasksTableState extends ConsumerState<TasksTable> {
  @override
  Widget build(BuildContext context) {
    final currentFilter = ref.watch(taskListFilter);

    return Scaffold(
      appBar: AppBar(title: const Text('Таблиця завдань')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _showModalButtomSheer,
            child: Text("Додати нове завдання"),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  ' ${ref.read(taskProvider.notifier).uncompletedCount()} items left',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Tooltip(
                message: 'All todos',
                child: TextButton(
                  onPressed: () => ref.read(taskListFilter.notifier).state =
                      TaskListFilter.all,
                  style: ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: WidgetStateProperty.all(
                      currentFilter == TaskListFilter.all
                          ? Colors.blue
                          : Colors.black,
                    ),
                  ),
                  child: const Text('All'),
                ),
              ),
              Tooltip(
                message: 'Time sorted',
                child: TextButton(
                  onPressed: () => ref.read(taskListFilter.notifier).state =
                      TaskListFilter.time,
                  style: ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: WidgetStateProperty.all(
                      currentFilter == TaskListFilter.time
                          ? Colors.blue
                          : Colors.black,
                    ),
                  ),
                  child: const Text('Time'),
                ),
              ),
              Tooltip(
                message: 'Only uncompleted todos',
                child: TextButton(
                  onPressed: () => ref.read(taskListFilter.notifier).state =
                      TaskListFilter.active,
                  style: ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: WidgetStateProperty.all(
                      currentFilter == TaskListFilter.active
                          ? Colors.blue
                          : Colors.black,
                    ),
                  ),
                  child: const Text('Active'),
                ),
              ),
              Tooltip(
                message: 'Only completed todos',
                child: TextButton(
                  onPressed: () => ref.read(taskListFilter.notifier).state =
                      TaskListFilter.completed,
                  style: ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: WidgetStateProperty.all(
                      currentFilter == TaskListFilter.completed
                          ? Colors.blue
                          : Colors.black,
                    ),
                  ),
                  child: const Text('Completed'),
                ),
              ),
            ],
          ),
          Expanded(child: DataTableWidget()),
        ],
      ),
    );
  }

  void _showModalButtomSheer() {
    showModalBottomSheet(context: context, builder: (ctx) => NewtaskScreen());
  }
}
