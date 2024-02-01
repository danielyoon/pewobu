import 'package:flutter/foundation.dart';
import 'package:todo_list/core_packages.dart';

import 'package:todo_list/controller/logic/bucket_logic.dart';
import 'package:todo_list/controller/logic/personal_logic.dart';
import 'package:todo_list/controller/logic/work_logic.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PersonalLogic personalLogic = PersonalLogic();
  await personalLogic.loadData('personal');

  WorkLogic workLogic = WorkLogic();
  await workLogic.loadData('work');

  BucketLogic bucketLogic = BucketLogic();
  await bucketLogic.loadData('bucket');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => personalLogic),
        ChangeNotifierProvider(create: (context) => workLogic),
        ChangeNotifierProvider(create: (context) => bucketLogic),
      ],
      child: const NoNameList(),
    ),
  );
}

class NoNameList extends StatelessWidget {
  const NoNameList({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        debugShowCheckedModeBanner: !kDebugMode,
        routerConfig: appRouter,
      );
}
