import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:todo_list/router.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  registerSingletons();

  // FlutterNativeSplash.remove();

  runApp(const NoNameList());
}

class NoNameList extends StatelessWidget {
  const NoNameList({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        debugShowCheckedModeBanner: !kDebugMode,
        routerConfig: appRouter,
      );
}

void registerSingletons() {}
