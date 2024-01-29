import 'package:carousel_slider/carousel_slider.dart';
import 'package:todo_list/controller/logic/todo_list_logic.dart';
import 'package:todo_list/controller/models/todo_data.dart';
import 'package:todo_list/controller/utils/color_utils.dart';
import 'package:todo_list/controller/utils/string_utils.dart';
import 'package:todo_list/core_packages.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animationController;
  late Animation<Color?> _animation;
  final ValueNotifier<Color> _backgroundColor = ValueNotifier<Color>(kPersonal);

  String timeOfDay = '';
  String dateOfToday = '';

  int currentIndex = 0;
  late CarouselController _carouselController;

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour >= 5 && hour < 12) {
      timeOfDay = 'morning';
    } else if (hour >= 12 && hour < 17) {
      timeOfDay = 'afternoon';
    } else {
      timeOfDay = 'evening';
    }

    dateOfToday = DateFormat('MMMM dd, yyyy').format(now).toUpperCase();
    _carouselController = CarouselController();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = ColorTween(
      begin: kPersonal,
      end: Colors.blue,
    ).animate(_animationController);

    _backgroundColor.addListener(() {
      _animation = ColorTween(
        begin: _animation.value,
        end: _backgroundColor.value,
      ).animate(_animationController);

      _animationController.forward(from: 0.0);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _backgroundColor.dispose();
    super.dispose();
  }

  void changeBackground(int index) {
    _backgroundColor.value = ColorUtils.getColorFromIndex(index);
  }

  void _handleOnTap(int index) {
    if (currentIndex == index) appRouter.push('/task/${StringUtils.getTitleFromIndex(index)}');
    _carouselController.animateToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final todoLogic = Provider.of<TodoListLogic>(context);
    TodoData personal = todoLogic.personalList;
    TodoData work = todoLogic.workList;
    TodoData bucket = todoLogic.bucketList;

    int numberOfTasks = todoLogic.getDueTodayTasks();

    double availableHeight =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top - 315;

    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      extendBodyBehindAppBar: true,
      body: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return SafeArea(
            top: false,
            child: Container(
              color: _animation.value,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(kToolbarHeight + kSmall),
                  _buildWelcomeMessage(numberOfTasks),
                  _buildCarouselList(personal, work, bucket, availableHeight),
                  Gap(kLarge),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  //TODO: Build side drawer (but for what use?)
  AppBar _buildAppBar() {
    return AppBar(
      title: Text('TODO', style: kSubHeader.copyWith(fontSize: kSmall + 2)),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.menu_rounded, color: kWhite),
        onPressed: () => print('Open Drawer!'),
      ),
    );
  }

  Padding _buildWelcomeMessage(int numberOfTasks) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kLarge + 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(kSmall),
          CustomCircleAvatar(),
          Gap(kMedium),
          Text('Hello, Daniel.', style: kHeader),
          Gap(kExtraExtraSmall),
          Text('Good $timeOfDay!', style: kSubHeader),
          Text('You have $numberOfTasks tasks due today.', style: kSubHeader),
          Gap(kLarge),
          Text('Today: $dateOfToday', style: kSubHeader.copyWith(fontWeight: FontWeight.w900, fontSize: kSmall)),
          Gap(kSmall),
        ],
      ),
    );
  }

  Expanded _buildCarouselList(TodoData personal, TodoData work, TodoData bucket, double availableHeight) {
    return Expanded(
      child: CarouselSlider(
        carouselController: _carouselController,
        items: [
          CustomListCard(data: personal, index: 0, onTap: () => _handleOnTap(0)),
          CustomListCard(data: work, index: 1, onTap: () => _handleOnTap(1)),
          CustomListCard(data: bucket, index: 2, onTap: () => _handleOnTap(2)),
        ],
        options: CarouselOptions(
          height: availableHeight,
          enableInfiniteScroll: false,
          enlargeCenterPage: true,
          onPageChanged: (index, reason) {
            currentIndex = index;
            _backgroundColor.value = ColorUtils.getColorFromIndex(index);
          },
        ),
      ),
    );
  }
}
