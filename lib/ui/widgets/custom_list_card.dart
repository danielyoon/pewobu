import 'package:todo_list/core_packages.dart';
import 'package:todo_list/controller/models/todo_data.dart';
import 'package:todo_list/controller/utils/color_utils.dart';

class CustomListCard extends StatelessWidget {
  final TodoData data;
  final int index;
  final VoidCallback onTap;

  const CustomListCard({
    super.key,
    required this.data,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Icon getIconFromTitle() {
      switch (data.category) {
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

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kSmall),
          color: kWhite,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: kSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(kMedium),
              Hero(
                tag: '${data.category}-icon',
                child: Row(
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
                    Icon(Icons.more_vert_rounded, color: kGrey),
                  ],
                ),
              ),
              Spacer(),
              Text('${'1'} Tasks', style: kSubHeader.copyWith(color: kGrey)),
              Text('1', style: kHeader.copyWith(color: kTextColor.withOpacity(.6))),
              Gap(kMedium),
              Row(
                children: [
                  Expanded(
                    child: CustomProgressBar(
                        completionPercentage: ((1 / 17) * 100).round(), color: ColorUtils.getColorFromIndex(index)),
                  ),
                  Gap(kExtraExtraSmall),
                  Text('${((1 / 17) * 100).round()}%'),
                ],
              ),
              Gap(kMedium),
            ],
          ),
        ),
      ),
    );
  }
}
