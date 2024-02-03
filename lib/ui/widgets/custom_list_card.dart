import 'package:animations/animations.dart';
import 'package:todo_list/controller/logic/base_todo_provider.dart';
import 'package:todo_list/core_packages.dart';
import 'package:todo_list/controller/utils/color_utils.dart';
import 'package:todo_list/ui/screens/todo_screen.dart';

class CustomListCard extends StatelessWidget {
  final BaseTodoProvider provider;
  final String title;

  const CustomListCard({super.key, required this.provider, required this.title});

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

    return Container(
      margin: EdgeInsets.symmetric(horizontal: kSmall),
      child: OpenContainer<bool>(
        transitionType: ContainerTransitionType.fade,
        openBuilder: (BuildContext context, VoidCallback _) {
          return TodoScreen(title: title, provider: provider);
        },
        tappable: false,
        closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kSmall)),
        closedElevation: kExtraSmall,
        closedBuilder: (BuildContext context, VoidCallback openContainer) {
          return InkWell(
            borderRadius: BorderRadius.circular(kMedium),
            onTap: openContainer,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: kSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(kMedium),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(kExtraExtraSmall),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: kGrey.withOpacity(.4)),
                        ),
                        child: getIconFromTitle(),
                      ),
                      IconButton(
                        icon: Icon(Icons.more_vert_rounded, color: kGrey),
                        onPressed: () => debugPrint('This is for aesthetics'),
                      )
                    ],
                  ),
                  Spacer(),
                  Text('${provider.getNumberOfUncompletedTasks()} Tasks', style: kSubHeader.copyWith(color: kGrey)),
                  Text(title, style: kHeader.copyWith(color: kTextColor.withOpacity(.6))),
                  Gap(kMedium),
                  Row(
                    children: [
                      Expanded(
                        child: CustomProgressBar(
                            completionPercentage: provider.getRoundedPercentageOfCompletedTasks(),
                            color: ColorUtils.getColorFromTitle(title)),
                      ),
                      Gap(kExtraExtraSmall),
                      Text('${provider.getRoundedPercentageOfCompletedTasks()}%'),
                    ],
                  ),
                  Gap(kMedium),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
