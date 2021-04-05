import 'package:flutter/foundation.dart';
import 'package:risa2/src/globals.dart';

import '../api/json_models/response/login_resp.dart';
import '../api/services/auth_service.dart';
import '../const.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authservice;
  AuthProvider(this._authservice);

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;
  void removeLogin() {
    // because builder run many time
    _isLoggedIn = false;
  }

  LoginRespData? _userData;
  LoginRespData? get userData => _userData;

  Future<bool> login(String id, String password) {
    return _authservice.login(id, password).then((response) {
      if (response.data != null) {
        _userData = response.data;
        if (_userData?.accessToken != "") {
          _saveDataToPersistent(_userData!.accessToken);
          return true;
        }
      } else if (response.error != null) {
        return Future.error(response.error!.message);
      }
      return false;
    });
  }

  void logout() {
    _saveDataToPersistent("");
    notifyListeners();
  }

  _saveDataToPersistent(String token) async {
    await App.localStorage!.setString(tokenSaved, token);
  }
}
