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

  void removeTask(Task task) {
    bool traverseAndRemove(List<Task> currentTasks, String title) {
      for (int i = 0; i < currentTasks.length; i++) {
        if (currentTasks[i].title == title) {
          currentTasks.removeAt(i);
          bool noOtherTaskWithSubcategory = !tasks.any((t) => t.subcategory == task.subcategory);
          if (noOtherTaskWithSubcategory) {
            subcategory.remove(task.subcategory);
          }
          return true;
        }
        if (traverseAndRemove(currentTasks[i].dependencies, title)) {
          return true;
        }
      }
      return false;
    }

    traverseAndRemove(tasks, task.title);
    notifyListeners();
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

  bool addDependency(Task task, String title) {
    Task? t = findTaskByCriterion(tasks, (Task t) => t.title == task.title);
    if (t != null) return true;

    Task? currentTask = findTaskByCriterion(tasks, (Task t) => t.title == title);
    currentTask?.addDependency(task);
    notifyListeners();
    return false;
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

  int getNumberOfUncompletedTasks() {
    int count = 0;

    void traverseTasks(List<Task> currentTasks) {
      for (var task in currentTasks) {
        if (!task.isCompleted) {
          count++;
        }
        if (task.dependencies.isNotEmpty) {
          traverseTasks(task.dependencies);
        }
      }
    }

    traverseTasks(tasks);
    return count;
  }

  List<Task> getTasksDueToday() {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    List<Task> allTasksDueToday = [];

    void traverseTasks(List<Task> currentTasks) {
      for (var task in currentTasks) {
        if (task.due != null && !task.isCompleted && task.due!.isAtSameMomentAs(today)) allTasksDueToday.add(task);
        if (task.dependencies.isNotEmpty) {
          traverseTasks(task.dependencies);
        }
      }
    }

    traverseTasks(tasks);
    return allTasksDueToday;
  }

  List<Task> getUncompletedTasks(String category) {
    List<Task> uncompletedTasks = [];

    void traverseTasks(List<Task> currentTasks) {
      for (var task in currentTasks) {
        if ((!task.isCompleted || !_allDependenciesCompleted(task)) &&
            task.subcategory != 'misc' &&
            task.subcategory == category) {
          uncompletedTasks.add(task);
        }
        if (task.dependencies.isNotEmpty) {
          traverseTasks(task.dependencies);
        }
      }
    }

    traverseTasks(tasks);
    return uncompletedTasks;
  }

  List<Task> getCompletedTasks() {
    List<Task> getCompletedTasks = [];

    for (var task in tasks) {
      if ((task.rootIndex != null || task.dependentOn == null) && task.isCompleted && _allDependenciesCompleted(task)) {
        getCompletedTasks.add(task);
      }
    }

    return getCompletedTasks;
  }

  int getRoundedPercentageOfCompletedTasks() {
    if (tasks.isEmpty) return 0;
    int completedTasks = getCompletedTasks().length;
    int uncompletedTasks = getNumberOfUncompletedTasks();

    double percentage = (completedTasks / (completedTasks + uncompletedTasks)) * 100;
    return percentage.round();
  }

  List<Task> getMiscTasks() {
    List<Task> miscTasks = [];

    void traverseTasks(List<Task> currentTasks) {
      for (var task in currentTasks) {
        if (task.subcategory == 'misc' && !task.isCompleted && _allDependenciesCompleted(task)) {
          miscTasks.add(task);
        }
        if (task.dependencies.isNotEmpty) {
          traverseTasks(task.dependencies);
        }
      }
    }

    traverseTasks(tasks);
    return miscTasks;
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

  bool _allDependenciesCompleted(Task task) {
    if (task.dependencies.isEmpty) return true;
    for (Task d in task.dependencies) {
      if (!d.isCompleted || !_allDependenciesCompleted(d)) return false;
    }
    return true;
  }
}
