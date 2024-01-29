import 'package:todo_list/core_packages.dart';
import 'package:todo_list/ui/screens/home_screen.dart';
import 'package:todo_list/ui/screens/todo_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  redirect: _handleRedirect,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
      routes: [
        GoRoute(
          path: 'task/:title',
          builder: (BuildContext context, GoRouterState state) {
            final title = state.pathParameters['title'];
            return TodoScreen(title: title!);
          },
        )
      ],
    ),
  ],
);

String? _handleRedirect(BuildContext context, GoRouterState state) {
  return null;
}
