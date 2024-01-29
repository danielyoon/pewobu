import 'package:todo_list/core_packages.dart';

class TodoScreen extends StatelessWidget {
  final String title;

  const TodoScreen({super.key, required this.title});

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

    return Scaffold(
      backgroundColor: kBucket,
      body: Center(
        child: Hero(
          tag: '$title-icon',
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
      ),
    );
  }
}
