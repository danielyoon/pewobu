import 'package:todo_list/controller/logic/base_todo_provider.dart';
import 'package:todo_list/core_packages.dart';
import 'package:todo_list/controller/models/task.dart';

class CustomCheckbox extends StatefulWidget {
  final BaseTodoProvider provider;
  final Task task;

  const CustomCheckbox({super.key, required this.task, required this.provider});

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(widget.task.title),
      leading: SizedBox(
        height: kMedium,
        width: kMedium,
        child: Checkbox(
          value: widget.task.isCompleted,
          onChanged: (bool? value) {
            setState(() {
              widget.provider.toggleTask(widget.task);
            });
          },
        ),
      ),
    );
  }
}
