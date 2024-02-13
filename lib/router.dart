import 'package:pewobu/controller/logic/auth_logic.dart';
import 'package:pewobu/core_packages.dart';
import 'package:pewobu/ui/screens/add_task_screen.dart';
import 'package:pewobu/ui/screens/home_screen.dart';
import 'package:pewobu/ui/screens/login_screen.dart';

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
            return AddTaskScreen(title: title as String);
          },
        ),
      ],
    ),
  ],
);

String? _handleRedirect(BuildContext context, GoRouterState state) {
  final bool isLoggedIn = Provider.of<AuthLogic>(context, listen: false).isLoggedIn;

  debugPrint('Navigating to ${state.fullPath}');

  if (!isLoggedIn && state.fullPath != '/login') return '/login';
  if (isLoggedIn && state.fullPath == '/login') return '/';
  return null;
}
