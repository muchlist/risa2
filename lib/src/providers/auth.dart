import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/json_models/response/login_resp.dart';
import '../api/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  String _token = '';
  String get token => _token;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  void removeLogin() {
    // because builder run many time
    _isLoggedIn = false;
  }

  String? _error;
  String? get error => _error;
  void removeError() {
    _error = null;
  }

  LoginRespData? _userData;
  LoginRespData? get userData => _userData;

  void login(String id, String password) async {
    _error = null;
    _isLoading = true;
    notifyListeners();

    await AuthService().login(id, password).then((response) {
      if (response.data != null) {
        _userData = response.data;
        if (_userData?.accessToken != "") {
          _saveDataToPersistent(_userData!.accessToken);
          _token = _userData!.accessToken;
          _isLoggedIn = true;
        }
      } else if (response.error != null) {
        _error = response.error!.message;
      }
    }, onError: (exeption) {
      _error = exeption.toString();
    });

    _isLoading = false;
    notifyListeners();
  }

  void logout() {
    _saveDataToPersistent("");
    _token = "";
    notifyListeners();
  }

  _saveDataToPersistent(String token) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
  }

  loadToken() async {
    var prefs = await SharedPreferences.getInstance();
    _token = prefs.getString("token") ?? "";
  }
}
