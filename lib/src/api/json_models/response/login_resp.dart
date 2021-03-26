import 'package:json_annotation/json_annotation.dart';

import 'error_resp.dart';

part 'login_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class LoginResponse {
  final ErrorResp? error;
  final LoginRespData? data;

  LoginResponse(this.error, this.data);

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class LoginRespData {
  final String id;
  final String email;
  final String name;
  final String branch;
  @JsonKey(defaultValue: [])
  final List<String> roles;
  final String avatar;
  @JsonKey(name: "access_token")
  final String accessToken;
  @JsonKey(name: "refresh_token")
  final String refreshToken;
  final int expired;

  LoginRespData(this.id, this.email, this.name, this.branch, this.roles,
      this.avatar, this.accessToken, this.refreshToken, this.expired);

  factory LoginRespData.fromJson(Map<String, dynamic> json) =>
      _$LoginRespDataFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRespDataToJson(this);
}
