import 'package:flutter/foundation.dart';

import '../api/json_models/response/login_resp.dart';
import '../api/services/auth_service.dart';
import '../globals.dart';
import '../utils/enums.dart';

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
          _saveDataToPersistent(
              token: _userData!.accessToken,
              branch: _userData!.branch,
              name: _userData!.name,
              role: _userData!.roles);
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

  // sendFCMToken mengirimkan token firebase ke server, return true if success
  Future<bool> sendFCMToken(String token) async {
    try {
      final response = await _authservice.sendFCMToken(token);
      if (response.error != null) {
        return false;
      }
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  void logout() {
    _saveDataToPersistent(token: "", branch: "", name: "", role: []);
    notifyListeners();
  }

  _saveDataToPersistent(
      {required String token,
      required String name,
      required String branch,
      required List<String> role}) async {
    // // join array string to string comma separated
    // var roleString = "";
    // if (role.length != 0) {
    //   roleString = role.join(",");
    // }
    // await App.localStorage!.setString(tokenSaved, token);
    // await App.localStorage!.setString(nameSaved, name);
    // await App.localStorage!.setString(branchSaved, branch);
    // await App.localStorage!.setString(roleSaved, roleString);
    await App.setName(name);
    await App.setToken(token);
    await App.setBranch(branch);
    await App.setRoles(role);
  }
}
