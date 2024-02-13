import 'package:pewobu/controller/logic/base_todo_provider.dart';
import 'package:pewobu/controller/logic/bucket_logic.dart';
import 'package:pewobu/controller/logic/personal_logic.dart';
import 'package:pewobu/controller/logic/work_logic.dart';
import 'package:pewobu/core_packages.dart';

BaseTodoProvider getProvider(BuildContext context, String type) {
  switch (type.toLowerCase()) {
    case 'personal':
      return Provider.of<PersonalLogic>(context, listen: true);
    case 'work':
      return Provider.of<WorkLogic>(context, listen: true);
    case 'bucket':
      return Provider.of<BucketLogic>(context, listen: true);
    default:
      throw Exception('Unsupported Type');
  }
}
