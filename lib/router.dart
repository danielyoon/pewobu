import 'package:todo_list/controller/logic/base_todo_provider.dart';
import 'package:todo_list/core_packages.dart';
import 'package:todo_list/ui/screens/add_task_screen.dart';
import 'package:todo_list/ui/screens/home_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  redirect: _handleRedirect,
  routes: [
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
  return null;
}
