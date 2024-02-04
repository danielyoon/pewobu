import 'package:todo_list/controller/models/task.dart';
import 'package:todo_list/controller/utils/color_utils.dart';
import 'package:todo_list/core_packages.dart';
import 'package:todo_list/controller/logic/base_todo_provider.dart';

/*
* TODO: Toggle task is currently broken for dependencies
* TODO: Make category clickable to see all tasks in one page (?)
* TODO: Have a separate category for COMPLETED that only shows at the end
* TODO: Have sort by date due (today, tomorrow, this week, later)
* TODO: Add animation for FAB
* TODO: Add longTap edit menu
* TODO: Task cannot be marked as completed until ALL dependencies are completed
* */

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
                            Text(category.toUpperCase(), style: kBodyText.copyWith(fontWeight: FontWeight.w700)),
                            Column(
                              children: tasks.map((task) {
                                if (!task.hasDependency) {
                                  return CustomTaskViewer(task: task, provider: widget.provider);
                                } else {
                                  return Container();
                                }
                              }).toList(),
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

// class MyTreeView extends StatefulWidget {
//   const MyTreeView({super.key});
//
//   @override
//   State<MyTreeView> createState() => _MyTreeViewState();
// }
//
// class _MyTreeViewState extends State<MyTreeView> {
//   static const List<MyNode> roots = <MyNode>[
//     MyNode(
//       title: 'Root 1',
//       children: <MyNode>[
//         MyNode(
//           title: 'Node 1.1',
//           children: <MyNode>[
//             MyNode(title: 'Node 1.1.1'),
//             MyNode(title: 'Node 1.1.2'),
//           ],
//         ),
//         MyNode(title: 'Node 1.2'),
//       ],
//     ),
//     MyNode(
//       title: 'Root 2',
//       children: <MyNode>[
//         MyNode(
//           title: 'Node 2.1',
//           children: <MyNode>[
//             MyNode(title: 'Node 2.1.1'),
//           ],
//         ),
//         MyNode(title: 'Node 2.2')
//       ],
//     ),
//   ];
//
//   late final TreeController<MyNode> treeController;
//
//   @override
//   void initState() {
//     super.initState();
//     treeController = TreeController<MyNode>(
//       roots: roots,
//       childrenProvider: (MyNode node) => node.children,
//     );
//   }
//
//   @override
//   void dispose() {
//     treeController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return TreeView<MyNode>(
//       padding: EdgeInsets.zero,
//       shrinkWrap: true,
//       treeController: treeController,
//       nodeBuilder: (BuildContext context, TreeEntry<MyNode> entry) {
//         return MyTreeTile(
//           key: ValueKey(entry.node),
//           entry: entry,
//           onTap: () => treeController.toggleExpansion(entry.node),
//         );
//       },
//     );
//   }
// }
//
// class MyNode {
//   const MyNode({
//     required this.title,
//     this.children = const <MyNode>[],
//   });
//
//   final String title;
//   final List<MyNode> children;
// }
//
// class MyTreeTile extends StatelessWidget {
//   const MyTreeTile({
//     super.key,
//     required this.entry,
//     required this.onTap,
//   });
//
//   final TreeEntry<MyNode> entry;
//   final VoidCallback onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: TreeIndentation(
//         entry: entry,
//         guide: const IndentGuide.connectingLines(indent: 48),
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
//           child: Row(
//             children: [
//               FolderButton(
//                 isOpen: entry.hasChildren ? entry.isExpanded : null,
//                 onPressed: entry.hasChildren ? onTap : null,
//               ),
//               Text(entry.node.title),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
