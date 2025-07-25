import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plans/provider/TaskProvider.dart';

class DataTableWidget extends ConsumerWidget {
  const DataTableWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeList = ref.watch(filteredTodos);

    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('№')),
            DataColumn(label: Text('Назва')),
            DataColumn(label: Text('Година')),
            DataColumn(label: Text('✅')),
          ],
          rows: activeList.map((task) {
            return DataRow(
              key: ValueKey(task.id),
              cells: [
                DataCell(
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 1000),
                    opacity: task.done ? 0.2 : 1.0,
                    child: Text(task.id.toString()),
                  ),
                ),
                DataCell(
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text('Видалити завдання?'),
                          content: Text('Точно видалити "${task.name}"?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                ref
                                    .read(taskProvider.notifier)
                                    .deleteTask(task);
                                Navigator.of(ctx).pop();
                              },
                              child: Text('Так'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: Text('Скасувати'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 1000),
                      opacity: task.done ? 0.4 : 1.0,
                      child: Text(task.name),
                    ),
                  ),
                ),
                DataCell(
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 1000),
                    opacity: task.done ? 0.4 : 1.0,
                    child: Text(task.time),
                  ),
                ),
                DataCell(
                  Checkbox(
                    key: ValueKey('checkbox-${task.id}'),
                    value: task.done,
                    onChanged: (value) {
                      ref.read(taskProvider.notifier).toggleTask(task.id);
                    },
                    activeColor: Colors.green, // Зелений чекбокс
                    checkColor: Colors.white,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
