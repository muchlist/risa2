import 'package:shared_preferences/shared_preferences.dart';

class App {
  static const String _tokenSaved = "token";
  static const String _branchSaved = "branch";
  static const String _rolesSaved = "roles";
  static const String _nameSaved = "name";
  static const String _expiredSaved = "expired";
  static const String _fireTokenSaved = "firebaseToken";

  static late SharedPreferences localStorage;
  static Future<void> init() async {
    localStorage = await SharedPreferences.getInstance();
  }

  static String getToken() {
    return localStorage.getString(_tokenSaved) ?? "";
  }

  static Future<bool> setToken(String value) {
    return localStorage.setString(_tokenSaved, value);
  }

  static int getExpired() {
    return localStorage.getInt(_expiredSaved) ?? 0;
  }

  static Future<bool> setExpired(int value) {
    return localStorage.setInt(_expiredSaved, value);
  }

  static String? getFireToken() {
    return localStorage.getString(_fireTokenSaved);
  }

  static Future<bool> setFireToken(String value) {
    return localStorage.setString(_fireTokenSaved, value);
  }

  static String? getName() {
    return localStorage.getString(_nameSaved);
  }

  static Future<bool> setName(String value) {
    return localStorage.setString(_nameSaved, value);
  }

  static String? getBranch() {
    return localStorage.getString(_branchSaved);
  }

  static Future<bool> setBranch(String value) {
    return localStorage.setString(_branchSaved, value);
  }

  static List<String> getRoles() {
    final String? rolesString = localStorage.getString(_rolesSaved);
    if (rolesString != null && rolesString.isNotEmpty) {
      return rolesString.split(",");
    }
    return <String>[];
  }

  static Future<bool> setRoles(List<String> value) {
    String rolesString = "";
    if (value.isNotEmpty) {
      rolesString = value.join(",");
    }
    return localStorage.setString(_rolesSaved, rolesString);
  }
}
