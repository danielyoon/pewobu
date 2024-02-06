import 'package:carousel_slider/carousel_slider.dart';
import 'package:todo_list/controller/logic/auth_logic.dart';
import 'package:todo_list/controller/logic/bucket_logic.dart';
import 'package:todo_list/controller/logic/personal_logic.dart';
import 'package:todo_list/controller/logic/work_logic.dart';
import 'package:todo_list/controller/utils/color_utils.dart';
import 'package:todo_list/core_packages.dart';
import 'package:intl/intl.dart';

/*
* TODO: Make responsive for tablet sizes -- add LayoutBuilder*
* TODO: Add design for drawer
* TODO: Add functionality for Drawer tiles
* */

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

  @override
  Widget build(BuildContext context) {
    final personal = context.watch<PersonalLogic>();
    final work = context.watch<WorkLogic>();
    final bucket = context.watch<BucketLogic>();

    double availableHeight =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top - 315;

    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildHomeAppBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(child: Text('TODO-EY', style: kBodyText.copyWith(fontSize: kSmall + 2))),
            ListTile(title: Text('Change Image')),
            ListTile(title: Text('Change Name')),
            ListTile(title: Text('Toggle Dark Mode')),
          ],
        ),
      ),
      extendBodyBehindAppBar: true,
      body: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            color: _animation.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(kToolbarHeight + kSmall),
                _IntroWidget(
                    timeOfDay: timeOfDay, personal: personal, work: work, bucket: bucket, dateOfToday: dateOfToday),
                _buildCarousel(personal, work, bucket, availableHeight),
                Gap(kLarge),
              ],
            ),
          );
        },
      ),
    );
  }

  Expanded _buildCarousel(PersonalLogic personal, WorkLogic work, BucketLogic bucket, double availableHeight) {
    return Expanded(
      child: CarouselSlider(
        carouselController: _carouselController,
        items: [
          CustomListCard(provider: personal, title: 'Personal'),
          CustomListCard(provider: work, title: 'Work'),
          CustomListCard(provider: bucket, title: 'Bucket'),
        ],
        options: CarouselOptions(
          height: availableHeight,
          enableInfiniteScroll: false,
          onPageChanged: (index, reason) {
            currentIndex = index;
            _backgroundColor.value = ColorUtils.getColorFromIndex(index);
          },
        ),
      ),
    );
  }

  AppBar _buildHomeAppBar() {
    return AppBar(
      title: Text('TODO', style: kSubHeader.copyWith(fontSize: kSmall + 2)),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.menu_rounded, color: kWhite),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
    );
  }
}

class _IntroWidget extends StatelessWidget {
  const _IntroWidget({
    required this.timeOfDay,
    required this.personal,
    required this.work,
    required this.bucket,
    required this.dateOfToday,
  });

  final String timeOfDay;
  final PersonalLogic personal;
  final WorkLogic work;
  final BucketLogic bucket;
  final String dateOfToday;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthLogic>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kLarge + 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(kSmall),
          CustomCircleAvatar(),
          Gap(kMedium),
          Text('Hello, ${auth.name!}.', style: kHeader),
          Gap(kExtraExtraSmall),
          Text('Good $timeOfDay!', style: kSubHeader),
          Text(
              'You have ${personal.getTasksDueToday().length + work.getTasksDueToday().length + bucket.getTasksDueToday().length} tasks due today.',
              style: kSubHeader),
          Gap(kLarge),
          Text('TODAY: $dateOfToday', style: kSubHeader.copyWith(fontWeight: FontWeight.w900, fontSize: kSmall)),
          Gap(kSmall),
        ],
      ),
    );
  }
}
