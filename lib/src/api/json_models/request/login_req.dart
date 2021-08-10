import 'package:json_annotation/json_annotation.dart';

part 'login_req.g.dart';

// flutter pub run build_runner build
@JsonSerializable()
class LoginRequest {
  LoginRequest(
      {required this.username, required this.password, this.limit = 7776000});

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
  final String username;
  final String password;
  final int limit;

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
