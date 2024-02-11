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

  bool addTask(Task task) {
    Task? t = findTaskByCriterion(tasks, (Task t) => t.title == task.title);
    if (t != null) return true;

    tasks.add(task);
    subcategory.add(task.subcategory);

    notifyListeners();
    return false;
  }

  List<String> getAllTitles(List<Task> tasks) {
    List<String> allTitles = [];

    void traverseTasks(List<Task> currentTasks) {
      for (var task in currentTasks) {
        allTitles.add(task.title);
        if (task.dependencies.isNotEmpty) {
          traverseTasks(task.dependencies);
        }
      }
    }

    traverseTasks(tasks);
    return allTitles;
  }

  Task? findTaskByCriterion(List<Task> tasks, bool Function(Task) criteria) {
    for (var task in tasks) {
      if (criteria(task)) {
        return task;
      }
      if (task.dependencies.isNotEmpty) {
        Task? found = findTaskByCriterion(task.dependencies, criteria);
        if (found != null) {
          return found;
        }
      }
    }
    return null;
  }

  void toggleTask(Task task) {
    Task? currentTask = findTaskByCriterion(tasks, (Task t) => t.title == task.title);
    currentTask?.toggleTask();

    if (!currentTask!.isCompleted) {
      void uncheckDependencies(List<Task> dependencies) {
        for (Task d in dependencies) {
          if (d.isCompleted == true) {
            d.toggleTask();
            if (d.dependencies.isNotEmpty) {
              uncheckDependencies(d.dependencies);
            }
          }
        }
      }

      uncheckDependencies(currentTask.dependencies);
    }
    notifyListeners();
  }

  bool addDependency(Task task) {
    Task? t = findTaskByCriterion(tasks, (Task t) => t.title == task.title);

    if (t != null) return true;

    Task? currentTask = findTaskByCriterion(tasks, (Task t) => t.title == task.title);
    currentTask?.addDependency(task);
    notifyListeners();
    return false;
  }

  //TODO: Re-work every function below here

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

  List<Task> getMiscTasks() {
    List<Task> miscTasks = [];

    for (Task task in tasks) {
      if (task.subcategory == 'misc') {
        miscTasks.add(task);
      }
    }

    return miscTasks;
  }

  List<Task> getUncompletedTasks(String category) {
    List<Task> uncompletedTasks = [];

    for (Task task in tasks) {
      if (task.subcategory == category && task.dependentOn == null) {
        uncompletedTasks.add(task);
      }
    }

    return uncompletedTasks;
  }

  List<Task> getCompletedTasks() {
    List<Task> completedTasks = [];

    for (Task task in tasks) {
      if (task.isCompleted && _areAllDependenciesCompleted(task)) {
        completedTasks.add(task);
      }
    }

    return completedTasks;
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
    tasks = (map['tasks'] as List).map((taskData) => Task.fromJson(taskData)).toList();
    subcategory = SplayTreeSet<String>.from(map['subcategory']);
  }

  bool _areAllDependenciesCompleted(Task task) {
    for (Task dTask in task.dependencies) {
      if (!dTask.isCompleted || !_areAllDependenciesCompleted(dTask)) {
        return false;
      }
    }
    return true;
  }

  void removeTask(Task task) {
    tasks.remove(task);
    if (!tasks.any((t) => t.subcategory == task.subcategory)) subcategory.remove(task.subcategory);
    notifyListeners();
  }
}
