import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plans/data/task.dart';
import 'package:plans/provider/TaskProvider.dart';

class NewtaskScreen extends ConsumerStatefulWidget {
  const NewtaskScreen({super.key});

  @override
  ConsumerState<NewtaskScreen> createState() => _NewtaskScreenState();
}

class _NewtaskScreenState extends ConsumerState<NewtaskScreen> {
  final _titleController = TextEditingController();
  final _timeController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _timeController.addListener(_formatTimeInput);
  }

  void _formatTimeInput() {
    // Отримуємо текст із контролера, тобто що зараз написано в текстовому полі
    final text = _timeController.text;

    // Видаляємо всі двокрапки ':' із рядка, щоб працювати з "чистими" цифрами
    final newText = text.replaceAll(':', '');

    // Якщо довжина цифр 3 або більше — починаємо форматувати
    if (newText.length >= 3) {
      // Формуємо новий рядок у форматі "HH:MM"
      // Беремо перші 2 символи як години
      // Потім дві наступні як хвилини, але не більше 4 символів всього (2+2)
      final formatted =
          '${newText.substring(0, 2)}:${newText.substring(2, newText.length > 4 ? 4 : newText.length)}';

      // Позиція курсора в текстовому полі (де зараз стоїть каретка)
      final cursorPosition = _timeController.selection.baseOffset;

      // Оновлюємо значення текстового поля:
      // - ставимо новий відформатований текст
      // - ставимо курсор так, щоб він рухався вправо, якщо текст став довшим (наприклад, додали ':')
      _timeController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(
          offset: cursorPosition + (formatted.length > text.length ? 1 : 0),
        ),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _timeController.removeListener(_formatTimeInput);
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 100,
            decoration: const InputDecoration(label: Text('Task Name*')),
          ),
          SizedBox(height: 10),
          TextField(
            // тут знов баг коли я починаю стирати допустим 12:32 і достирую до цього 12: далі стирати я не можу, воно не дає, можливо щоб воно автоматично видалило?
            controller: _timeController,
            keyboardType: TextInputType.number,
            buildCounter:
                (
                  _, {
                  required int currentLength,
                  required bool isFocused,
                  required int? maxLength,
                }) => null,
            maxLength: 5,
            decoration: const InputDecoration(
              hint: Text("00:00"),
              label: Text('Time*'),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _submitData,
            child: const Text('Save Task'),
          ),
        ],
      ),
    );
  }

  bool _split(String time) {
    try {
      List<String> parts = time.split(":");
      int hours = int.parse(parts[0]);
      int minutes = int.parse(parts[1]);
      if ((hours >= 0 && hours < 24) && (minutes >= 0 && minutes < 60)) {
        return true;
      } else {
        throw Exception("Gandon");
      }
    } catch (e) {
      return false;
    }
  }

  void _submitData() {
    bool isGood = _split(_timeController.text);
    if (_titleController.text.trim().isEmpty ||
        _timeController.text.trim().isEmpty ||
        !isGood) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
            'Please make sure a valid title, amount, date and category was entered.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    } else {
      ref
          .read(taskProvider.notifier)
          .addTask(
            Task.positional(
              0,
              _titleController.text,
              _timeController.text,
              false,
            ),
          );

      Navigator.pop(context);
    }
  }
}
