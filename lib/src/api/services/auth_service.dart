import '../http_client.dart';
import '../json_models/response/login_resp.dart';
import '../json_parsers/json_parsers.dart';

class AuthService {
  const AuthService();

  Future<LoginResponse> login(String id, String password) {
    return RequestREST(
            endpoint: "/login",
            data: <String, dynamic>{"id": id, "password": password})
        .executePost<LoginResponse>(const LoginParser());
  }

  Future<LoginResponse> sendFCMToken(String token) {
    return RequestREST(
            endpoint: "/update-fcm",
            data: <String, dynamic>{"fcm_token": token})
        .executePost<LoginResponse>(const LoginParser());
  }
}
