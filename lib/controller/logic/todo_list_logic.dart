import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/controller/models/todo_data.dart';
import 'package:todo_list/controller/models/task.dart';

class TodoListLogic extends ChangeNotifier {
  late final TodoData personalList;
  late final TodoData workList;
  late final TodoData bucketList;

  void updateTodoList(TodoData listToUpdate, Task newTask) {
    listToUpdate.addTask(newTask);
    notifyListeners();
    saveTodoData();
  }

  int getDueTodayTasks() {
    DateTime now = DateTime.now();
    return _countDueTasks(personalList.tasks, now) +
        _countDueTasks(workList.tasks, now) +
        _countDueTasks(bucketList.tasks, now);
  }

  int getUncompletedTasks(String title) {
    if (title == 'personal') return _countUncompletedTasks(personalList.tasks);
    if (title == 'work') return _countUncompletedTasks(workList.tasks);
    if (title == 'bucket') return _countUncompletedTasks(bucketList.tasks);

    return 0;
  }

  int getCompletedTasks(String title) {
    if (title == 'personal') return _countCompletedTasks(personalList.tasks);
    if (title == 'work') return _countCompletedTasks(workList.tasks);
    if (title == 'bucket') return _countCompletedTasks(bucketList.tasks);

    return 0;
  }

  Set<String> getExistingCategories() {
    return {
      ...personalList.tasks.map((task) => task.subcategory),
      ...workList.tasks.map((task) => task.subcategory),
      ...bucketList.tasks.map((task) => task.subcategory),
    };
  }

  Future<void> saveTodoData() async {
    final prefs = await SharedPreferences.getInstance();

    String personalJsonString = jsonEncode(personalList.toJson());
    String workJsonString = jsonEncode(workList.toJson());
    String bucketJsonString = jsonEncode(bucketList.toJson());

    await prefs.setString('personal', personalJsonString);
    await prefs.setString('work', workJsonString);
    await prefs.setString('bucket', bucketJsonString);
  }

  Future<void> loadTodoData() async {
    final prefs = await SharedPreferences.getInstance();

    String? personalJsonString = prefs.getString('personal');
    String? workJsonString = prefs.getString('work');
    String? bucketJsonString = prefs.getString('bucket');

    personalList = personalJsonString != null
        ? TodoData.fromJson(jsonDecode(personalJsonString))
        : TodoData(category: 'Personal', subcategory: SplayTreeSet<String>(), tasks: []);
    workList = workJsonString != null
        ? TodoData.fromJson(jsonDecode(workJsonString))
        : TodoData(category: 'Work', subcategory: SplayTreeSet<String>(), tasks: []);
    bucketList = bucketJsonString != null
        ? TodoData.fromJson(jsonDecode(bucketJsonString))
        : TodoData(category: 'Bucket', subcategory: SplayTreeSet<String>(), tasks: []);

    notifyListeners();
  }

  int _countDueTasks(List<Task> tasks, DateTime now) {
    return tasks
        .where((task) =>
            task.due != null && task.due!.year == now.year && task.due!.month == now.month && task.due!.day == now.day)
        .length;
  }

  int _countCompletedTasks(List<Task> tasks) {
    return tasks.where((task) => task.isCompleted).length;
  }

  int _countUncompletedTasks(List<Task> tasks) {
    return tasks.where((task) => !task.isCompleted).length;
  }
}
