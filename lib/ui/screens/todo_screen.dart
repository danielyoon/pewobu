import 'package:flutter/scheduler.dart';
import 'package:todo_list/controller/logic/todo_list_logic.dart';
import 'package:todo_list/controller/utils/color_utils.dart';
import 'package:todo_list/core_packages.dart';

class TodoScreen extends StatefulWidget {
  final String title;

  const TodoScreen({super.key, required this.title});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _categoryController;
  bool addTask = false;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: '');
    _categoryController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _handleAddTask() {
    setState(() {
      addTask = !addTask;
    });
  }

  @override
  Widget build(BuildContext context) {
    final todoLogic = Provider.of<TodoListLogic>(context, listen: true);
    int uncompletedTasks = todoLogic.getUncompletedTasks(widget.title);
    int completedTasks = todoLogic.getCompletedTasks(widget.title);

    // List<String> categories = todoLogic.getExistingCategories().toList();
    List<String> categories = ['test', 'hello'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: addTask
            ? IconButton(icon: Icon(Icons.close, color: kGrey), onPressed: () => _handleAddTask())
            : BackButton(
                color: kGrey,
                onPressed: () => appRouter.pop(),
              ),
        title: addTask ? Text('New Task', style: kSubHeader.copyWith(fontSize: kSmall + 2, color: kGrey)) : Container(),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert_rounded, color: kGrey),
            onPressed: () => print('Open sort list'),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: ColorUtils.getColorFromTitle(widget.title),
        onPressed: () => _handleAddTask(),
        child: Icon(Icons.add, color: kWhite),
      ),
      body: AnimatedSwitcher(
        duration: Duration(seconds: 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(kToolbarHeight + kSmall * 2),
            addTask
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: kLarge + kSmall),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('What tasks are you planning to perform?', style: kBodyText.copyWith(color: kGrey)),
                        CustomTextField(
                          controller: _titleController,
                        ),
                        Text('What category does it fall under?', style: kBodyText.copyWith(color: kGrey)),
                        Autocomplete<String>(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text == '') {
                              return const Iterable<String>.empty();
                            }
                            return categories.where((String option) {
                              return option.contains(textEditingValue.text.toLowerCase());
                            });
                          },
                          optionsViewBuilder: (
                            BuildContext context,
                            AutocompleteOnSelected<String> onSelected,
                            Iterable<String> options,
                          ) {
                            const AutocompleteOptionToString<String> displayStringForOption =
                                RawAutocomplete.defaultStringForOption;
                            return Align(
                              alignment: Alignment.topLeft,
                              child: Material(
                                elevation: 4.0,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(maxHeight: 200, maxWidth: 300),
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: options.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      final String option = options.elementAt(index);
                                      return InkWell(
                                        onTap: () {
                                          onSelected(option);
                                        },
                                        child: Builder(builder: (BuildContext context) {
                                          final bool highlight = AutocompleteHighlightedOption.of(context) == index;
                                          if (highlight) {
                                            SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
                                              Scrollable.ensureVisible(context, alignment: 0.5);
                                            });
                                          }
                                          return Container(
                                            color: highlight ? Theme.of(context).focusColor : null,
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text(displayStringForOption(option)),
                                          );
                                        }),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                          onSelected: (String selection) {
                            _categoryController.text = selection;
                          },
                          fieldViewBuilder: (
                            BuildContext context,
                            TextEditingController fieldTextEditingController,
                            FocusNode fieldFocusNode,
                            VoidCallback onFieldSubmitted,
                          ) {
                            return TextField(
                              cursorColor: kGrey,
                              style: kBodyText,
                              controller: fieldTextEditingController,
                              focusNode: fieldFocusNode,
                              onSubmitted: (String value) {
                                onFieldSubmitted();
                              },
                              onChanged: (e) => print('TEST'),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            );
                          },
                        ),
                        Text('Does it depend on anything else?', style: kBodyText.copyWith(color: kGrey)),
                        //TODO: Add autocomplete here
                        Gap(kExtraLarge),
                        Text('Does it have a due date?', style: kBodyText.copyWith(color: kGrey))
                      ],
                    ),
                  )
                : TodoList(
                    uncompletedTasks: uncompletedTasks,
                    title: widget.title,
                    completedTasks: completedTasks,
                    key: ValueKey(false)),
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
        onPressed: () => appRouter.pop(),
      ),
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
                    completionPercentage: ((1 / 17) * 100).round(), color: ColorUtils.getColorFromTitle(title)),
              ),
              Gap(kExtraExtraSmall),
              Text(
                '${(uncompletedTasks + completedTasks) == 0 ? 0 : ((uncompletedTasks / (uncompletedTasks + completedTasks)) * 100).round()}%',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
