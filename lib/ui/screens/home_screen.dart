import 'package:carousel_slider/carousel_slider.dart';
import 'package:todo_list/core_packages.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String timeOfDay = '';
  String dateOfToday = '';
  int numberOfTasks = 3;

  late CarouselController _carouselController;
  ValueNotifier<Color> backgroundColorNotifier = ValueNotifier<Color>(kPersonal);

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
  }

  @override
  Widget build(BuildContext context) {
    Color? getColorFromNumber(int number) {
      switch (number) {
        case 0:
          return kPersonal;
        case 1:
          return kWork;
        case 2:
          return kBucket;
        default:
          return kPersonal;
      }
    }

    double availableHeight =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top - 315;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundColorNotifier.value,
      appBar: _buildAppBar(),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeMessage(),
            Expanded(
              child: CarouselSlider(
                carouselController: _carouselController,
                /*TODO: This list should be dynamically made for each
                         category + have empty card for creating new card */
                items: [
                  CustomListCard(title: 'Personal', onTap: () => print('TEST'), tasks: 1),
                  CustomListCard(
                    createNew: true,
                    onTap: () => _scaffoldKey.currentState!.showBottomSheet<void>(
                      (BuildContext context) {
                        return CustomCreateSheet();
                      },
                    ),
                  ),
                ],
                options: CarouselOptions(
                  height: availableHeight,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    backgroundColorNotifier.value = getColorFromNumber(index)!;
                  },
                ),
              ),
            ),
            Gap(kLarge),
          ],
        ),
      ),
    );
  }

  Padding _buildWelcomeMessage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kLarge + 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(kSmall),
          CustomCircleAvatar(),
          Gap(kLarge),
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
}
