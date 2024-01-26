import 'package:todo_list/controller/models/task.dart';

class TodoData {
  final String category;
  String? subcategory;
  List<Task> tasks = [];

  TodoData({required this.category, this.subcategory, required this.tasks});

  void addTask(Task task) {
    tasks.add(task);
  }

  void removeTask(Task task) {
    tasks.remove(task);
  }
}
