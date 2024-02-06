import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLogic extends ChangeNotifier {
  String? name;
  bool isLoggedIn = false;

  Future<void> login(String data) async {
    name = data;
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('auth', data);
    isLoggedIn = true;
    notifyListeners();
  }

  Future<void> getName() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('auth');

    if (data != null) {
      name = data;
      isLoggedIn = true;
      notifyListeners();
    }
  }
}
