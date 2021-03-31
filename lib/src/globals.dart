import 'package:shared_preferences/shared_preferences.dart';

class App {
  static SharedPreferences? localStorage;
  static Future init() async {
    localStorage = await SharedPreferences.getInstance();
  }
}
