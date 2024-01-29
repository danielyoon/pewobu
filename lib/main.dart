import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/router.dart';
import 'package:todo_list/controller/logic/todo_list_logic.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  TodoListLogic todoListLogic = TodoListLogic();
  await todoListLogic.loadTodoData();

  runApp(
    ChangeNotifierProvider(
      create: (context) => todoListLogic,
      child: const NoNameList(),
    ),
  );
}

class NoNameList extends StatelessWidget {
  const NoNameList({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        debugShowCheckedModeBanner: !kDebugMode,
        routerConfig: appRouter,
      );
}
