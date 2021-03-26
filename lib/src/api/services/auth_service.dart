import 'package:risa2/src/api/json_models/response/login_resp.dart';

import '../http_client.dart';
import '../json_parsers/json_parsers.dart';

class AuthService {
  const AuthService();

  Future<LoginResponse> login(String id, String password) {
    return RequestREST(
            endpoint: "/login", data: {"id": id, "password": password})
        .executePost<LoginResponse>(LoginParser());
  }
}
