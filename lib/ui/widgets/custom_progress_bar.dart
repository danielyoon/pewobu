import 'package:pewobu/core_packages.dart';

class CustomProgressBar extends StatelessWidget {
  final int completionPercentage;
  final Color color;

  const CustomProgressBar({super.key, required this.completionPercentage, required this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double fullWidth = constraints.maxWidth;
        double progressWidth = fullWidth * (completionPercentage / 100);

        return Stack(
          children: [
            Container(
              width: double.infinity,
              height: 3,
              decoration: BoxDecoration(
                color: kGrey.withOpacity(.5),
                borderRadius: BorderRadius.circular(kSmall),
              ),
            ),
            Container(
              width: progressWidth,
              height: 3,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(kSmall),
              ),
            ),
          ],
        );
      },
    );
  }
}
