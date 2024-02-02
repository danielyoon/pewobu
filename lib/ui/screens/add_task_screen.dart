import 'package:intl/intl.dart';
import 'package:todo_list/controller/logic/base_todo_provider.dart';
import 'package:todo_list/controller/utils/color_utils.dart';
import 'package:todo_list/core_packages.dart';
import 'package:todo_list/controller/models/task.dart';

class AddTaskScreen extends StatefulWidget {
  final BaseTodoProvider provider;
  final String title;

  const AddTaskScreen({super.key, required this.provider, required this.title});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _categoryController;
  late final TextEditingController _taskController;
  late final TextEditingController _dateController;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: '');
    _categoryController = TextEditingController(text: '');
    _taskController = TextEditingController(text: '');
    _dateController = TextEditingController(text: 'None');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _taskController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  //TODO: Setup form handling
  void _handleSubmit(BaseTodoProvider provider, BuildContext context) {
    DateTime? parsedDate;
    DateFormat format = DateFormat('MMM dd yy');
    if (_dateController.text.isNotEmpty && _dateController.text != 'None') {
      parsedDate = format.parse(_dateController.text);
    }

    Task? dependentTask;
    if (_taskController.text.isNotEmpty) {
      for (Task task in provider.tasks) {
        if (task.title == _taskController.text) {
          dependentTask = task;
        }
      }
    }

    Task newTask = Task(
      title: _titleController.text,
      subcategory: _categoryController.text,
      created: DateTime.now(),
      dependencies: [],
      due: parsedDate,
      hasDependency: dependentTask != null ? true : false,
    );

    if (dependentTask != null) dependentTask.addDependency(newTask);
    provider.addTask(newTask);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    List<String> categories = widget.provider.subcategory.toList();
    List<String> titles = widget.provider.tasks.map((task) => task.title).toList();

//TODO: Add error message somewhere
    return Scaffold(
      appBar: _buildAppBar(),
      extendBodyBehindAppBar: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(kToolbarHeight + kSmall * 2),
          Padding(
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
                ],
              ),
            ),
          ),
          Spacer(),
          _buildFAB(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.close, color: kGrey),
        onPressed: () => appRouter.pop(),
      ),
      title: Text('New Task', style: kSubHeader.copyWith(color: kTextColor.withOpacity(.6))),
    );
  }

  SizedBox _buildFAB() {
    return SizedBox(
      width: double.infinity,
      child: FloatingActionButton.extended(
        extendedPadding: EdgeInsets.zero,
        heroTag: '${widget.title}-button',
        onPressed: () => _handleSubmit(widget.provider, context),
        label: Icon(Icons.add),
        backgroundColor: ColorUtils.getColorFromTitle(widget.title),
        foregroundColor: kWhite,
        shape: ContinuousRectangleBorder(),
      ),
    );
  }
}
