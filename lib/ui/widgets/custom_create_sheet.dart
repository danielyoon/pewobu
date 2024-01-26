import 'package:todo_list/core_packages.dart';

class CustomCreateSheet extends StatelessWidget {
  const CustomCreateSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Column(
        children: [
          Gap(kMedium),
          Text('Create a New List', style: kSubHeader.copyWith(color: kTextColor)),
        ],
      ),
    );
  }
}
