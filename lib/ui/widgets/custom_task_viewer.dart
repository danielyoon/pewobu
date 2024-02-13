import 'package:pewobu/core_packages.dart';
import 'package:pewobu/controller/models/task.dart';

/*
* TODO: Draw a grey arrow of some sort showing connection between tasks
* */

class CustomTaskViewer extends StatelessWidget {
  final Task task;
  final String title;

  const CustomTaskViewer({super.key, required this.task, required this.title});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomCheckbox(task: task, title: title),
          Padding(
            padding: EdgeInsets.only(left: kLarge),
            child: Column(
              children: task.dependencies.map((task) => CustomTaskViewer(task: task, title: title)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
