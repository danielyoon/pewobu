import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/controller/utils/debouncer.dart';

class AuthLogic extends ChangeNotifier {
  String? name;
  bool isLoggedIn = false;

  final Debouncer _debouncer = Debouncer(delay: Duration(milliseconds: 500));

  void login(String data) async {
    name = data;
    final prefs = await SharedPreferences.getInstance();

    _debouncer.run(() async => await prefs.setString('auth', data));
    isLoggedIn = true;
    notifyListeners();
  }

  Future<void> getName() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('auth');

    if (name != null) {
      name = data;
      isLoggedIn = true;
      notifyListeners();
    }
  }
}
