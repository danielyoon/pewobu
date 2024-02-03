import 'package:todo_list/controller/logic/base_todo_provider.dart';

class BucketLogic extends BaseTodoProvider {
  @override
  Future<void> saveData(String category) async {
    await super.saveData('bucket');
  }
}
