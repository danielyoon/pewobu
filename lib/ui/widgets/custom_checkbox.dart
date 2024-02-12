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
    return GestureDetector(
      onLongPress: () {
        provider.removeTask(widget.task);
        provider.saveData(widget.title.toLowerCase());
      },
      child: Container(
        color: Colors.transparent, // Makes the entire container clickable
        height: isTwoLines && !largeWidth ? kLarge + 8 : kLarge + 2,
        child: Row(
          children: <Widget>[
            SizedBox(
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
            SizedBox(width: 8), // Spacing between checkbox and text
            Expanded(
              child: Text(
                widget.task.title,
                style: TextStyle(
                    // Add text style if needed
                    ),
              ),
            ),
            // Add trailing widgets if needed
          ],
        ),
      ),
    );
  }
}
