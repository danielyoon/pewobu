import 'package:todo_list/controller/logic/base_todo_provider.dart';
import 'package:todo_list/controller/utils/color_utils.dart';
import 'package:todo_list/core_packages.dart';
import 'package:todo_list/controller/models/task.dart';
import 'package:todo_list/controller/utils/provider_util.dart';

class CustomCheckbox extends StatefulWidget {
  final String title;
  final Task task;
  final bool isEnabled;

  const CustomCheckbox({super.key, required this.task, required this.title, this.isEnabled = true});

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  @override
  Widget build(BuildContext context) {
    BaseTodoProvider provider = getProvider(context, widget.title);

    bool isTwoLines = widget.task.title.length > 28;
    bool largeWidth = context.widthPx > 480;
    return SizedBox(
      height: isTwoLines && !largeWidth ? kLarge + 8 : kLarge,
      child: ListTile(
        enabled: widget.isEnabled,
        contentPadding: EdgeInsets.zero,
        title: Text(widget.task.title),
        leading: SizedBox(
          height: kMedium,
          width: kMedium,
          child: Checkbox(
            activeColor: ColorUtils.getColorFromTitle(widget.title),
            value: widget.task.isCompleted,
            onChanged: (bool? value) {
              setState(() {
                provider.toggleTask(widget.task);
              });
            },
          ),
        ),
      ),
    );
  }
}
