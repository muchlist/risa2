import 'package:shared_preferences/shared_preferences.dart';

class App {
  static final tokenSaved = "token";
  static final branchSaved = "branch";
  static final rolesSaved = "roles";
  static final nameSaved = "name";

  static late SharedPreferences localStorage;
  static Future init() async {
    localStorage = await SharedPreferences.getInstance();
  }

  static String? getToken() {
    return localStorage.getString(tokenSaved);
  }

  static Future<bool> setToken(String value) {
    return localStorage.setString(tokenSaved, value);
  }

  static String? getName() {
    return localStorage.getString(nameSaved);
  }

  static Future<bool> setName(String value) {
    return localStorage.setString(nameSaved, value);
  }

  static String? getBranch() {
    return localStorage.getString(branchSaved);
  }

  static Future<bool> setBranch(String value) {
    return localStorage.setString(branchSaved, value);
  }

  static List<String> getRoles() {
    final rolesString = localStorage.getString(rolesSaved);
    if (rolesString != null && rolesString.isNotEmpty) {
      return rolesString.split(",");
    }
    return [];
  }

  static Future<bool> setRoles(List<String> value) {
    var rolesString = "";
    if (value.length != 0) {
      rolesString = value.join(",");
    }
    return localStorage.setString(rolesSaved, rolesString);
  }
}
