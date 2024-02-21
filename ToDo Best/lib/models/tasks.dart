import 'package:todo/constants/new_task_type.dart';

class Task {
  int id;
  final TaskType type;
  final String title;
  final String description;
  bool isCompleted;
  final String timeAdded;

  Task({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.timeAdded,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.toString(),
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'timeAdded': timeAdded,
    };
  }

  static TaskType convertIntToTaskType(int taskTypeIndex) {
    switch (taskTypeIndex) {
      case 0:
        return TaskType.morning;
      case 1:
        return TaskType.afternoon;
      case 2:
        return TaskType.evening;
      default:
        return TaskType.unknown;
    }
  }
}
