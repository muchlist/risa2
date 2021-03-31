import 'package:flutter/foundation.dart';
import 'package:risa2/src/globals.dart';

import '../api/json_models/response/login_resp.dart';
import '../api/services/auth_service.dart';
import '../const.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  void removeLogin() {
    // because builder run many time
    _isLoggedIn = false;
  }

  LoginRespData? _userData;
  LoginRespData? get userData => _userData;

  Future<bool> login(String id, String password) {
    _isLoading = true;
    notifyListeners();

    return AuthService().login(id, password).then((response) {
      if (response.data != null) {
        _userData = response.data;
        if (_userData?.accessToken != "") {
          _saveDataToPersistent(_userData!.accessToken);
          _isLoading = false;
          notifyListeners();
          return true;
        }
      } else if (response.error != null) {
        _isLoading = false;
        notifyListeners();
        return Future.error(response.error!.message);
      }
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  void logout() {
    _saveDataToPersistent("");
    notifyListeners();
  }

  _saveDataToPersistent(String token) async {
    await App.localStorage!.setString(TOKEN_SAVED, token);
  }
}
