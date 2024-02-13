import 'package:flutter/foundation.dart';
import 'package:pewobu/controller/logic/auth_logic.dart';
import 'package:pewobu/core_packages.dart';
import 'package:pewobu/controller/logic/bucket_logic.dart';
import 'package:pewobu/controller/logic/personal_logic.dart';
import 'package:pewobu/controller/logic/work_logic.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AuthLogic authLogic = AuthLogic();
  await authLogic.getName();

  PersonalLogic personalLogic = PersonalLogic();
  await personalLogic.loadData('personal');
  WorkLogic workLogic = WorkLogic();
  await workLogic.loadData('work');
  BucketLogic bucketLogic = BucketLogic();
  await bucketLogic.loadData('bucket');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => authLogic),
        ChangeNotifierProvider(create: (context) => personalLogic),
        ChangeNotifierProvider(create: (context) => workLogic),
        ChangeNotifierProvider(create: (context) => bucketLogic),
      ],
      child: const Pewobu(),
    ),
  );
}

class Pewobu extends StatelessWidget {
  const Pewobu({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        debugShowCheckedModeBanner: !kDebugMode,
        routerConfig: appRouter,
      );
}
