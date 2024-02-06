import 'package:todo_list/controller/logic/auth_logic.dart';
import 'package:todo_list/core_packages.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleSubmit(BuildContext context) async {
    if (_nameController.text.isEmpty) return;
    await Provider.of<AuthLogic>(context, listen: false)
        .login(_nameController.text);
    appRouter.go('/');
    return;
  }

  @override
  Widget build(BuildContext context) {
    double width = context.widthPx;

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: width / 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Enter your name',
                  style: kHeader.copyWith(fontSize: kMedium)),
              CustomTextField(
                autoFocus: true,
                controller: _nameController,
                onSubmit: (e) => _handleSubmit(context),
              ),
              _buildLoginButton(context),
            ],
          ),
        ),
      ),
    );
  }

  IconButton _buildLoginButton(BuildContext context) {
    return IconButton(
      splashRadius: 0.1,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      icon: Icon(Icons.arrow_circle_right, color: kWhite),
      onPressed: () => _handleSubmit(context),
    );
  }
}
