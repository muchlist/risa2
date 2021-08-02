import 'package:shared_preferences/shared_preferences.dart';

class App {
  static final _tokenSaved = "token";
  static final _branchSaved = "branch";
  static final _rolesSaved = "roles";
  static final _nameSaved = "name";
  static final _expiredSaved = "expired";
  static final _fireTokenSaved = "firebaseToken";

  static late SharedPreferences localStorage;
  static Future init() async {
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
    final rolesString = localStorage.getString(_rolesSaved);
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
    return localStorage.setString(_rolesSaved, rolesString);
  }
}
