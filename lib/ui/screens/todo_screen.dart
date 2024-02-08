import 'package:todo_list/controller/models/task.dart';
import 'package:todo_list/controller/utils/color_utils.dart';
import 'package:todo_list/core_packages.dart';
import 'package:todo_list/controller/logic/base_todo_provider.dart';
import 'package:todo_list/controller/utils/provider_util.dart';

/*
* TODO: Toggle task is currently broken for dependencies (?)
* TODO: When a task is completed, move to COMPLETED section UNLESS it has dependencies
* TODO: Make category clickable to see all tasks in one page (?)
* TODO: Have a separate category for COMPLETED that only shows at the end
* TODO: Have sort by date due (today, tomorrow, this week, later)
* TODO: Add animation for FAB
* TODO: Add longTap edit menu
* TODO: Task shouldn't be marked as completed until ALL dependencies are completed
* TODO: Add underline for each task UNLESS it has dependencies
* */

class TodoScreen extends StatefulWidget {
  final String title;

  const TodoScreen({super.key, required this.title});

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

    BaseTodoProvider provider = getProvider(context, widget.title);

    return Scaffold(
      appBar: _buildAppBar(),
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
        heroTag: '${widget.title}-button',
        shape: CircleBorder(),
        backgroundColor: ColorUtils.getColorFromTitle(widget.title),
        onPressed: () => _navigateToAdd(provider),
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
                  Column(
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
                      Text('${provider.getNumberOfUncompletedTasks()} Tasks', style: kSubHeader.copyWith(color: kGrey)),
                      Text(widget.title, style: kHeader.copyWith(color: kTextColor.withOpacity(.6))),
                      Gap(kMedium),
                      Row(
                        children: [
                          Expanded(
                            child: CustomProgressBar(
                                completionPercentage: provider.getRoundedPercentageOfCompletedTasks(),
                                color: ColorUtils.getColorFromTitle(widget.title)),
                          ),
                          Gap(kExtraExtraSmall),
                          Text('${provider.getRoundedPercentageOfCompletedTasks()}%'),
                        ],
                      ),
                      Gap(kSmall),
                    ],
                  ),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: provider.tasks.length,
                    itemBuilder: (context, index) {
                      if (index < provider.subcategory.length) {
                        if (provider.subcategory.elementAt(index).toLowerCase() == 'misc') return Container();
                        String category = provider.subcategory.elementAt(index);
                        List<Task> tasks = provider.getSubcategory(provider.subcategory.elementAt(index));
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                height: kSmall + 4,
                                child: Text(category.toUpperCase(),
                                    style: kBodyText.copyWith(fontWeight: FontWeight.w700))),
                            Column(
                              children: tasks.map((task) {
                                if (!task.hasDependency) {
                                  return CustomTaskViewer(task: task, provider: provider, color: widget.title);
                                } else {
                                  return Container();
                                }
                              }).toList(),
                            ),
                            Gap(kMedium),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  Gap(kExtraSmall),
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
      scrolledUnderElevation: 0,
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
