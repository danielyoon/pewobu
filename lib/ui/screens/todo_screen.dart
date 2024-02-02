import 'package:todo_list/controller/models/task.dart';
import 'package:todo_list/controller/utils/color_utils.dart';
import 'package:todo_list/core_packages.dart';
import 'package:todo_list/controller/logic/base_todo_provider.dart';

class TodoScreen extends StatefulWidget {
  final String title;
  final BaseTodoProvider provider;

  const TodoScreen({super.key, required this.title, required this.provider});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  void _navigateToAdd(BaseTodoProvider provider) {
    appRouter.push('/add/${widget.title}', extra: provider);
  }

  @override
  Widget build(BuildContext context) {
    Icon getIconFromTitle() {
      switch (widget.title) {
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

    return Scaffold(
      appBar: _buildAppBar(),
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
        heroTag: '${widget.title}-button',
        shape: CircleBorder(),
        backgroundColor: ColorUtils.getColorFromTitle(widget.title),
        onPressed: () => _navigateToAdd(widget.provider),
        child: Icon(Icons.add, color: kWhite),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(kToolbarHeight + kSmall * 2),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kLarge + kSmall),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(kExtraExtraSmall),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: kGrey.withOpacity(.4)),
                    ),
                    child: getIconFromTitle(),
                  ),
                  Gap(kMedium),
                  Text('${widget.provider.getNumberOfUncompletedTasks()} Tasks',
                      style: kSubHeader.copyWith(color: kGrey)),
                  Text(widget.title, style: kHeader.copyWith(color: kTextColor.withOpacity(.6))),
                  Gap(kMedium),
                  Row(
                    children: [
                      Expanded(
                        child: CustomProgressBar(
                            completionPercentage: widget.provider.getRoundedPercentageOfCompletedTasks(),
                            color: ColorUtils.getColorFromTitle(widget.title)),
                      ),
                      Gap(kExtraExtraSmall),
                      Text('${widget.provider.getRoundedPercentageOfCompletedTasks()}%'),
                    ],
                  ),
                  Gap(kSmall),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.provider.tasks.length,
                    itemBuilder: (context, index) {
                      if (index < widget.provider.subcategory.length) {
                        String category = widget.provider.subcategory.elementAt(index);
                        List<Task> tasks = widget.provider.getSubcategory(widget.provider.subcategory.elementAt(index));
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(category.toUpperCase(), style: kBodyText),
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: tasks.length,
                              itemBuilder: (context, taskIndex) {
                                Task task = tasks[taskIndex];
                                return Text(task.title);
                              },
                            ),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: BackButton(
        color: kGrey,
        onPressed: () => Navigator.pop(context, true),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.more_vert_rounded, color: kGrey),
          onPressed: () => print('Open sort list'),
        ),
      ],
    );
  }
}

class TodoList extends StatelessWidget {
  const TodoList({
    super.key,
    required this.uncompletedTasks,
    required this.title,
    required this.completedTasks,
  });

  final int uncompletedTasks;
  final String title;
  final int completedTasks;

  @override
  Widget build(BuildContext context) {
    Icon getIconFromTitle() {
      switch (title) {
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

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kLarge + kSmall),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(kExtraExtraSmall),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: kGrey.withOpacity(.4)),
              ),
              child: getIconFromTitle(),
            ),
            Gap(kMedium),
            Text('$uncompletedTasks Tasks', style: kSubHeader.copyWith(color: kGrey)),
            Text(title, style: kHeader.copyWith(color: kTextColor.withOpacity(.6))),
            Gap(kMedium),
            Row(
              children: [
                Expanded(
                  child: CustomProgressBar(
                      completionPercentage: (uncompletedTasks + completedTasks) == 0
                          ? 0
                          : ((uncompletedTasks / (uncompletedTasks + completedTasks)) * 100).round(),
                      color: ColorUtils.getColorFromTitle(title)),
                ),
                Gap(kExtraExtraSmall),
                Text(
                  '${(uncompletedTasks + completedTasks) == 0 ? 0 : ((uncompletedTasks / (uncompletedTasks + completedTasks)) * 100).round()}%',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
