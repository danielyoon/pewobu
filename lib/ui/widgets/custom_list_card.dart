import 'package:dotted_border/dotted_border.dart';
import 'package:todo_list/core_packages.dart';
import 'package:todo_list/controller/models/todo_data.dart';

class CustomListCard extends StatelessWidget {
  final String? title;
  final int? tasks;
  final VoidCallback onTap;
  final bool createNew;

  const CustomListCard({super.key, this.title, required this.onTap, this.tasks, this.createNew = false});

  @override
  Widget build(BuildContext context) {
    return createNew ? NewCard(onTap: onTap) : TaskListCard(todo: null, onTap: onTap);
  }
}

class NewCard extends StatelessWidget {
  final VoidCallback onTap;

  const NewCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        dashPattern: const [8, 10],
        color: kWhite,
        borderType: BorderType.Rect,
        radius: Radius.circular(kMedium),
        child: Center(
          child: Text('Create New', style: kHeader.copyWith(fontSize: kLarge)),
        ),
      ),
    );
  }
}

class TaskListCard extends StatelessWidget {
  final TodoData? todo;
  final VoidCallback onTap;

  const TaskListCard({super.key, required this.todo, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Icon getIconFromTitle() {
      switch (todo?.category) {
        case 'Personal':
          return Icon(Icons.person, color: kPersonal);
        case 'Work':
          return Icon(Icons.shopping_bag_rounded, color: kWork);
        case 'Bucket':
          return Icon(Icons.star, color: kBucket);
        default:
          return Icon(Icons.person, color: kPersonal);
      }
    }

    Color getColorFromTitle() {
      switch (todo.category) {
        case 'Personal':
          return kPersonal;
        case 'Work':
          return kWork;
        case 'Bucket':
          return kBucket;
        default:
          return kPersonal;
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kSmall),
          color: kWhite,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: kSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(kMedium),
              _buildIconRow(getIconFromTitle),
              Spacer(),
              Text('${todo.tasks.length} Tasks', style: kSubHeader.copyWith(color: kGrey)),
              Text(todo.category, style: kHeader.copyWith(color: kTextColor.withOpacity(.6))),
              Gap(kMedium),
              Row(
                children: [
                  Expanded(
                    child: CustomProgressBar(
                        completionPercentage: ((todo.tasks.length / 17) * 100).round(), color: getColorFromTitle()),
                  ),
                  Gap(kExtraExtraSmall),
                  Text('${((todo.tasks.length / 17) * 100).round()}%'),
                ],
              ),
              Gap(kMedium),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildIconRow(Icon Function() getIconFromTitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.all(kExtraExtraSmall),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: kGrey.withOpacity(.4)),
          ),
          child: getIconFromTitle(),
        ),
        Icon(Icons.more_vert_rounded, color: kGrey),
      ],
    );
  }
}
