import 'dart:collection';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/controller/models/task.dart';
import 'package:todo_list/core_packages.dart';
import 'package:todo_list/controller/utils/debouncer.dart';

class BaseTodoProvider extends ChangeNotifier {
  List<Task> tasks = [];
  SplayTreeSet<String> subcategory = SplayTreeSet();

  final Debouncer _debouncer = Debouncer(delay: Duration(milliseconds: 500));

  void addTask(Task task) {
    tasks.add(task);
    subcategory.add(task.subcategory);
    notifyListeners();
  }

  void deleteTask(Task task) {
    if (tasks.contains(task)) {
      tasks.remove(task);
      notifyListeners();
    }
  }

  void toggleTask(Task task) {
    if (tasks.any((e) => e.title == task.title)) {
      task.toggleTask();
      notifyListeners();
    }
  }

  void addDependency(String title, Task task) {
    Task currentTask = tasks.firstWhere((task) => task.title == title);
    currentTask.addDependency(task);
    notifyListeners();
  }

  void removeTask(Task task) {
    tasks.remove(task);
    if (!tasks.any((t) => t.subcategory == task.subcategory)) subcategory.remove(task.subcategory);
    notifyListeners();
  }

  int getNumberOfUncompletedTasks() {
    return tasks.where((task) => !task.isCompleted).length;
  }

  List<Task> getSubcategory(String category) {
    return tasks.where((task) => task.subcategory == category).toList();
  }

  List<Task> getTasksDueToday() {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    return tasks.where((task) => task.due != null && !task.isCompleted && task.due!.isAtSameMomentAs(today)).toList();
  }

  int getRoundedPercentageOfCompletedTasks() {
    if (tasks.isEmpty) return 0;
    int completedTasks = tasks.where((task) => task.isCompleted).length;
    double percentage = (completedTasks / tasks.length) * 100;
    return percentage.round();
  }

  Future<void> saveData(String category) async {
    final prefs = await SharedPreferences.getInstance();
    String data = jsonEncode({
      'subcategory': subcategory.toList(),
      'tasks': tasks.map((task) => task.toJson()).toList(),
    });
    _debouncer.run(() async => await prefs.setString(category, data));
  }

  Future<void> loadData(String category) async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(category);

    if (data == null) return;

    Map<String, dynamic> map = jsonDecode(data);
    tasks = List<Task>.from(map['tasks'].map((task) => Task.fromJson(task)));
    subcategory = SplayTreeSet<String>.from(map['subcategory']);
  }
}
