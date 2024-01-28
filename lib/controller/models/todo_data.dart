import 'dart:collection';

import 'package:todo_list/controller/models/task.dart';

class TodoData {
  final String category;
  SplayTreeSet<String> subcategory = SplayTreeSet<String>();
  List<Task> tasks = [];

  TodoData({required this.category, required this.subcategory, required this.tasks});

  void addTask(Task task) {
    tasks.add(task);
    subcategory.add(task.subcategory);
  }

  void removeTask(Task task) {
    tasks.remove(task);
    if (!tasks.any((t) => t.subcategory == task.subcategory)) {
      subcategory.remove(task.subcategory);
    }
  }
}
