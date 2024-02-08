import 'package:todo_list/controller/logic/base_todo_provider.dart';
import 'package:todo_list/core_packages.dart';
import 'package:todo_list/controller/models/task.dart';

/*
* TODO: Add indentation for each dependency level
* TODO: Have same level indentation
* TODO: Draw a grey arrow of some sort showing connection between tasks
* */

class CustomTaskViewer extends StatelessWidget {
  final Task task;
  final BaseTodoProvider provider;
  final String color;

  const CustomTaskViewer({super.key, required this.task, required this.provider, required this.color});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomCheckbox(task: task, provider: provider, color: color),
          Padding(
            padding: EdgeInsets.only(left: kLarge),
            child: Column(
              children: task.dependencies
                  .map((task) => CustomTaskViewer(task: task, provider: provider, color: color))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
