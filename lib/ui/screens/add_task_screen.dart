import 'package:intl/intl.dart';
import 'package:todo_list/controller/logic/base_todo_provider.dart';
import 'package:todo_list/controller/utils/color_utils.dart';
import 'package:todo_list/core_packages.dart';
import 'package:todo_list/controller/models/task.dart';
import 'package:todo_list/controller/utils/provider_util.dart';

/*
* TODO: Setup a prettier error text
* TODO: Better design for some fields?
* TODO: Make this more responsive for shorter screens
* TODO: Make it 2 columns (on larger screens) where the second column shows the Task created
* */

class AddTaskScreen extends StatefulWidget {
  final String title;

  const AddTaskScreen({super.key, required this.title});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _categoryController;
  late final TextEditingController _taskController;
  late final TextEditingController _dateController;

  String errorText = '';

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
    errorText = '';
    if (_titleController.text.isNotEmpty) {
      DateTime? parsedDate;
      DateFormat format = DateFormat('MMM dd yy');
      if (_dateController.text.isNotEmpty && _dateController.text != 'No') {
        parsedDate = format.parse(_dateController.text);
      }

      Task? dependentTask;
      String? dependentOn;
      int? rootIndex;
      if (_taskController.text.isNotEmpty) {
        dependentTask = provider.findTaskByCriterion(provider.tasks, (Task t) => t.title == _taskController.text);
        dependentOn = dependentTask?.title;
        if (dependentTask != null) {
          if (dependentTask.rootIndex != null) {
            rootIndex = dependentTask.rootIndex;
          } else {
            rootIndex = provider.tasks.indexOf(dependentTask);
          }
        }
      }

      Task newTask = Task(
        title: _titleController.text,
        subcategory: _categoryController.text.isEmpty ? 'misc' : _categoryController.text,
        created: DateTime.now(),
        dependencies: [],
        due: parsedDate,
        dependentOn: dependentOn,
        rootIndex: rootIndex,
      );

      bool duplicateExists = false;
      if (dependentTask != null) {
        duplicateExists = provider.addDependency(newTask);
      } else {
        duplicateExists = provider.addTask(newTask);
      }

      if (duplicateExists) {
        setState(() {
          errorText = 'The same task already exists!';
        });
        return;
      }
      provider.saveData('');
      Navigator.pop(context);
    }
    setState(() {
      errorText = 'Please enter a title!';
    });
  }

  @override
  Widget build(BuildContext context) {
    BaseTodoProvider provider = getProvider(context, widget.title);

    List<String> categories = provider.subcategory.toList();
    List<String> titles = provider.getAllTitles(provider.tasks);

    double width = context.widthPx;
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
                            errorText = '';
                          })),
                  if (errorText.isNotEmpty) ...[
                    Container(
                        width: width / 2,
                        padding: EdgeInsets.symmetric(horizontal: kExtraSmall, vertical: kExtraExtraSmall),
                        decoration: BoxDecoration(
                            border: Border.all(color: kError), borderRadius: BorderRadius.circular(kExtraExtraSmall)),
                        child: Text(errorText, style: kBodyText.copyWith(color: kError))),
                    Gap(kExtraSmall),
                  ],
                  Text('What category does it fall under?', style: kBodyText.copyWith(color: kGrey)),
                  CustomAutocomplete(
                      categories: categories, controller: _categoryController, onChanged: (_) => setState(() {})),
                  Text('Does it depend on anything else?', style: kBodyText.copyWith(color: kGrey)),
                  CustomAutocomplete(
                      categories: titles, controller: _taskController, isEnabled: _categoryController.text.isNotEmpty),
                  Text('Does it have a due date?', style: kBodyText.copyWith(color: kGrey)),
                  Gap(kSmall),
                  CustomCalendar(controller: _dateController),
                ],
              ),
            ),
          ),
          Spacer(),
          _buildFAB(provider, context),
        ],
      ),
    );
  }

  SizedBox _buildFAB(BaseTodoProvider provider, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FloatingActionButton.extended(
        extendedPadding: EdgeInsets.zero,
        heroTag: '${widget.title}-button',
        onPressed: () => _handleSubmit(provider, context),
        label: Icon(Icons.add),
        backgroundColor: ColorUtils.getColorFromTitle(widget.title),
        foregroundColor: kWhite,
        shape: ContinuousRectangleBorder(),
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
}
