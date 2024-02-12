import 'package:todo_list/controller/logic/base_todo_provider.dart';
import 'package:todo_list/controller/utils/color_utils.dart';
import 'package:todo_list/core_packages.dart';
import 'package:todo_list/controller/models/task.dart';
import 'package:todo_list/controller/utils/provider_util.dart';

class CustomCheckbox extends StatefulWidget {
  final String title;
  final Task task;

  const CustomCheckbox({super.key, required this.task, required this.title});

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  @override
  Widget build(BuildContext context) {
    BaseTodoProvider provider = getProvider(context, widget.title);

    bool isTwoLines = widget.task.title.length > 28;
    bool largeWidth = context.widthPx > 480;

    Task? t;
    bool canCompleteTask = false;
    bool isDependent = widget.task.dependentOn != null;
    if (isDependent) {
      t = provider.findTaskByCriterion(provider.tasks, (Task t) => t.title == widget.task.dependentOn);
      if (t!.isCompleted) {
        canCompleteTask = true;
      }
    } else {
      canCompleteTask = true;
    }
    return SizedBox(
      height: isTwoLines && !largeWidth ? kLarge + 8 : kLarge,
      child: Theme(
        data: ThemeData(splashColor: Colors.transparent, highlightColor: Colors.transparent),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(widget.task.title),
          onLongPress: () {
            provider.removeTask(widget.task);
            provider.saveData(widget.title.toLowerCase());
          },
          leading: SizedBox(
            height: kMedium,
            width: kMedium,
            child: Checkbox(
              activeColor: ColorUtils.getColorFromTitle(widget.title),
              value: widget.task.isCompleted,
              onChanged: canCompleteTask
                  ? (bool? value) {
                      provider.toggleTask(widget.task);
                      provider.saveData(widget.title.toLowerCase());
                    }
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
