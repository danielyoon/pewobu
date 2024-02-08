import 'package:intl/intl.dart';
import 'package:todo_list/controller/logic/base_todo_provider.dart';
import 'package:todo_list/controller/utils/color_utils.dart';
import 'package:todo_list/core_packages.dart';
import 'package:todo_list/controller/models/task.dart';

/*
* TODO: Make this more responsive for shorter screens
* TODO: Make it 2 columns (on larger screens) where the second column shows the Task created
* TODO: Add verification of adding a new Task
* TODO: Search existing tasks to prevent same title task
* TODO: Setup a prettier error text
* TODO: Autocomplete should be fixed to handle both uppercase and lowercase letters
* TODO: Better design for some fields?
* */

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

  bool showErrorText = false;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: '');
    _categoryController = TextEditingController(text: '');
    _taskController = TextEditingController(text: '');
    _dateController = TextEditingController(text: 'No');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _taskController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _handleSubmit(BaseTodoProvider provider, BuildContext context) {
    showErrorText = false;
    if (_titleController.text.isNotEmpty) {
      DateTime? parsedDate;
      DateFormat format = DateFormat('MMM dd yy');
      if (_dateController.text.isNotEmpty && _dateController.text != 'No') {
        parsedDate = format.parse(_dateController.text);
      }

      Task? dependentTask;
      int? dependencyIndex;
      if (_taskController.text.isNotEmpty) {
        for (int i = 0; i < provider.tasks.length; i++) {
          if (provider.tasks[i].title == _taskController.text) {
            dependentTask = provider.tasks[i];
            dependencyIndex = i;
          }
        }
      }

      Task newTask = Task(
        title: _titleController.text,
        subcategory: _categoryController.text.isEmpty ? 'misc' : _categoryController.text,
        created: DateTime.now(),
        dependencies: [],
        due: parsedDate,
        dependencyIndex: dependencyIndex,
      );

      if (dependentTask != null) dependentTask.addDependency(newTask);
      provider.addTask(newTask);
      provider.saveData('');
      Navigator.pop(context);
    }
    setState(() {
      showErrorText = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> categories = widget.provider.subcategory.toList();
    List<String> titles = widget.provider.tasks.map((task) => task.title).toList();

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
                      autoFocus: true,
                      onChanged: (_) => setState(() {
                            showErrorText = false;
                          })),
                  if (showErrorText) ...[
                    Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: kExtraSmall, vertical: kExtraExtraSmall),
                        decoration: BoxDecoration(
                            border: Border.all(color: kError), borderRadius: BorderRadius.circular(kExtraExtraSmall)),
                        child: Text('Please enter a title!', style: kBodyText.copyWith(color: kError))),
                    Gap(kExtraSmall),
                  ],
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
      title: Text('New Task', style: kSubHeader.copyWith(color: kTextColor.withOpacity(.6), fontSize: kSmall)),
      centerTitle: true,
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
