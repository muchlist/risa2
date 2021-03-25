import 'package:flutter/cupertino.dart';
import 'package:risa2/src/api/http_client.dart';
import 'package:risa2/src/api/json_models/login_resp.dart';
import 'package:risa2/src/api/json_parsers/json_parsers.dart';

class AuthModel extends ChangeNotifier {
  String _token = '';
  String get latestToken => _token;

  LoginRespData? userData;
  String? error;

  void updateToken(String token) {
    _token = token;
    notifyListeners();
  }

  login(String username, String password) async {
    await RequestREST(
            endpoint: "/login", data: {"id": username, "password": password})
        .executePost<LoginResponse>(LoginParser())
        .then((response) {
      if (response.data != null) {
        userData = response.data;
      } else if (response.error != null) {
        error = response.error!.message;
      }
    }, onError: (exeption) {
      error = exeption.toString();
    });

    notifyListeners();
  }
}
