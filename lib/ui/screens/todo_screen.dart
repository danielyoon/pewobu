import 'package:intl/intl.dart';
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
  late final TextEditingController _titleController;
  late final TextEditingController _categoryController;
  late final TextEditingController _taskController;
  late final TextEditingController _dateController;
  bool addTask = false;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: '');
    _categoryController = TextEditingController(text: '');
    _taskController = TextEditingController(text: '');
    _dateController = TextEditingController(text: 'Today');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _taskController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _handleAddTask() {
    setState(() {
      addTask = !addTask;
    });
  }

  // void _handleSubmit(String title) {
  //   DateTime? parsedDate;
  //   DateFormat format = DateFormat('MMM dd yy');
  //   if (_dateController.text.isNotEmpty && _dateController.text != 'Today') {
  //     parsedDate = format.parse(_dateController.text);
  //   }
  //
  //   Task? dependentTask;
  //   if (_taskController.text.isNotEmpty) {
  //     for (Task task in list!.tasks) {
  //       if (task.title == _taskController.text) {
  //         dependentTask = task;
  //       }
  //     }
  //   }
  //
  //   Task newTask = Task(
  //     title: _titleController.text,
  //     subcategory: _categoryController.text,
  //     created: DateTime.now(),
  //     due: parsedDate,
  //     dependency: dependentTask,
  //   );
  //
  //   todoLogic.updateTodoList(title, newTask);
  //   _titleController.text = '';
  //   _categoryController.text = '';
  //   _taskController.text = '';
  //   _dateController.text = 'Today';
  //   _handleAddTask();
  //   return;
  // }

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

    // List<String> categories = todoLogic.getExistingCategories(widget.title).toList();
    // List<String> titles = todoLogic.getExistingTasks(widget.title).toList();

    return PopScope(
      canPop: addTask ? false : true,
      onPopInvoked: (canPop) {
        if (addTask) {
          _handleAddTask();
        }
        () => Navigator.pop(context, true);
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        extendBodyBehindAppBar: true,
        floatingActionButton: addTask
            ? Container()
            : FloatingActionButton(
                shape: CircleBorder(),
                backgroundColor: ColorUtils.getColorFromTitle(widget.title),
                onPressed: () => _handleAddTask(),
                child: Icon(Icons.add, color: kWhite),
              ),
        body: AnimatedSwitcher(
          duration: Duration(seconds: 1),
          child: SingleChildScrollView(
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
                            List<Task> tasks =
                                widget.provider.getSubcategory(widget.provider.subcategory.elementAt(index));
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(category, style: kBodyText),
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
                addTask
                    ? GestureDetector(
                        onTap: () => print('TEST'),
                        child: Container(
                          padding: EdgeInsets.zero,
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(color: ColorUtils.getColorFromTitle(widget.title)),
                          child: Icon(Icons.add, color: kWhite),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: addTask
          ? IconButton(icon: Icon(Icons.close, color: kGrey), onPressed: () => _handleAddTask())
          : BackButton(
              color: kGrey,
              onPressed: () => Navigator.pop(context, true),
            ),
      title: addTask ? Text('New Task', style: kSubHeader.copyWith(fontSize: kSmall + 2, color: kGrey)) : Container(),
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

class AddTaskForm extends StatelessWidget {
  const AddTaskForm({
    super.key,
    required TextEditingController titleController,
    required this.categories,
    required TextEditingController categoryController,
    required this.titles,
    required TextEditingController taskController,
    required TextEditingController dateController,
  })  : _titleController = titleController,
        _categoryController = categoryController,
        _taskController = taskController,
        _dateController = dateController;

  final TextEditingController _titleController;
  final List<String> categories;
  final TextEditingController _categoryController;
  final List<String> titles;
  final TextEditingController _taskController;
  final TextEditingController _dateController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: kLarge + kSmall),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('What task are you planning to perform?', style: kBodyText.copyWith(color: kGrey)),
              CustomTextField(
                controller: _titleController,
              ),
              Text('What category does it fall under?', style: kBodyText.copyWith(color: kGrey)),
              CustomAutocomplete(categories: categories, controller: _categoryController),
              Text('Does it depend on anything else?', style: kBodyText.copyWith(color: kGrey)),
              CustomAutocomplete(categories: titles, controller: _taskController),
              Text('Does it have a due date?', style: kBodyText.copyWith(color: kGrey)),
              Gap(kSmall),
              CustomCalendar(controller: _dateController),
              Spacer(),
            ],
          ),
        ),
      ),
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
