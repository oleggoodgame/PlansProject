class Task {
  final int id;
  final String name;
  final String time;
  final bool done;

  const Task({
    required this.id,
    required this.name,
    required this.time,
    required this.done,
  });
  const Task.positional(this.id, this.name, this.time, this.done);
  Task copyWith({
    int? id,
    String? name,
    String? time,
    bool? done,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      time: time ?? this.time,
      done: done ?? this.done,
    );
  }
}
