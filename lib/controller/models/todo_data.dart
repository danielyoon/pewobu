import 'dart:collection';

import 'package:todo_list/controller/models/task.dart';

class TodoData {
  final String category;
  SplayTreeSet<String> subcategory;
  List<Task> tasks;

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

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'subcategory': subcategory.toList(),
      'tasks': tasks.map((task) => task.toJson()).toList(),
    };
  }

  factory TodoData.fromJson(Map<String, dynamic> jsonData) {
    return TodoData(
      category: jsonData['category'],
      subcategory: SplayTreeSet<String>.from(jsonData['subcategory']),
      tasks: List<Task>.from(jsonData['tasks'].map((task) => Task.fromJson(task))),
    );
  }
}
