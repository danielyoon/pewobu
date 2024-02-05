import 'package:todo_list/core_packages.dart';

/*
* TODO: Create a HYPER-simplistic login page
* TODO:
* */

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextField(),
        ],
      ),
    );
  }
}
