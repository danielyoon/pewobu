import 'package:intl/intl.dart';
import 'package:todo_list/core_packages.dart';

class CustomCalendar extends StatefulWidget {
  final TextEditingController controller;

  const CustomCalendar({super.key, required this.controller});

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  @override
  Widget build(BuildContext context) {
    double width = context.widthPx;

    return GestureDetector(
      onTap: () async {
        DateTime? due = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 365 * 2)),
          barrierColor: kGrey,
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: kGrey,
                ),
              ),
              child: child!,
            );
          },
        );

        if (due != null) {
          String formattedDate = DateFormat('MMM dd yy').format(due);
          setState(() {
            widget.controller.text = formattedDate;
          });
        }
      },
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: width > 500 ? width / 2.5 : width),
        child: Container(
          padding: EdgeInsets.only(bottom: kExtraExtraSmall),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: kGrey,
                width: .5,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                color: kGrey,
              ),
              Gap(kSmall),
              Text(widget.controller.text, style: kSubHeader),
            ],
          ),
        ),
      ),
    );
  }
}
