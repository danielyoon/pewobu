import 'dart:collection';

import 'package:todo_list/controller/models/todo_data.dart';
import 'package:todo_list/controller/models/task.dart';

List<TodoData> list = [
  TodoData(category: 'Personal', tasks: [], subcategory: SplayTreeSet<String>()),
  TodoData(category: 'Work', tasks: [], subcategory: SplayTreeSet<String>()),
];
