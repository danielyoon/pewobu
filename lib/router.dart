import 'package:todo_list/controller/logic/auth_logic.dart';
import 'package:todo_list/controller/logic/base_todo_provider.dart';
import 'package:todo_list/core_packages.dart';
import 'package:todo_list/ui/screens/add_task_screen.dart';
import 'package:todo_list/ui/screens/home_screen.dart';
import 'package:todo_list/ui/screens/login_screen.dart';

/*
* TODO: If user never logged in before (for now, use shared_preferences), navigate to login
* */

final appRouter = GoRouter(
  initialLocation: '/',
  redirect: _handleRedirect,
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
      routes: [
        GoRoute(
          path: 'add/:title',
          builder: (context, state) {
            final title = state.pathParameters['title'];
            return AddTaskScreen(
              provider: state.extra as BaseTodoProvider,
              title: title as String,
            );
          },
        ),
      ],
    ),
  ],
);

String? _handleRedirect(BuildContext context, GoRouterState state) {
  final bool isLoggedIn = Provider.of<AuthLogic>(context, listen: false).isLoggedIn;

  if (!isLoggedIn) return '/login';
  return null;
}
