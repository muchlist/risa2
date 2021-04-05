import 'package:flutter/foundation.dart';
import 'package:risa2/src/globals.dart';
import 'package:risa2/src/utils/enums.dart';

import '../api/json_models/response/login_resp.dart';
import '../api/services/auth_service.dart';
import '../const.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authservice;
  AuthProvider(this._authservice);

  ViewState _state = ViewState.idle;
  ViewState get state => _state;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  LoginRespData? _userData;
  LoginRespData? get userData => _userData;

  Future<bool> login(String id, String password) async {
    setState(ViewState.busy);

    var error = "";
    try {
      final response = await _authservice.login(id, password);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _userData = response.data;
        if (_userData?.accessToken != "") {
          _saveDataToPersistent(_userData!.accessToken);
          return true;
        }
      }
    } catch (e) {
      error = e.toString();
    }

    setState(ViewState.idle);

    if (error.isNotEmpty) {
      return Future.error(error);
    }
    return false;
  }

  void logout() {
    _saveDataToPersistent("");
    notifyListeners();
  }

  _saveDataToPersistent(String token) async {
    await App.localStorage!.setString(tokenSaved, token);
  }
}
