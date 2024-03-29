import 'package:pewobu/controller/logic/auth_logic.dart';
import 'package:pewobu/core_packages.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _nameController;
  late final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: '');

    WidgetsBinding.instance
        .addPostFrameCallback((_) => Future.delayed(Duration(milliseconds: 300), () => _focusNode.requestFocus()));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSubmit(BuildContext context) async {
    if (_nameController.text.isEmpty) return;
    await Provider.of<AuthLogic>(context, listen: false).login(_nameController.text);
    appRouter.go('/');
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 250),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Enter your name', style: kHeader.copyWith(fontSize: kMedium)),
              CustomTextField(
                  focusNode: _focusNode,
                  controller: _nameController,
                  onSubmit: (e) {
                    FocusScope.of(context).unfocus();
                    _handleSubmit(context);
                  }),
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
