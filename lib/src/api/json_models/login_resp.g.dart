// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) {
  return LoginResponse(
    json['error'] == null
        ? null
        : ErrorResp.fromJson(json['error'] as Map<String, dynamic>),
    json['data'] == null
        ? null
        : LoginRespData.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'error': instance.error?.toJson(),
      'data': instance.data?.toJson(),
    };

LoginRespData _$LoginRespDataFromJson(Map<String, dynamic> json) {
  return LoginRespData(
    json['id'] as String,
    json['email'] as String,
    json['name'] as String,
    json['branch'] as String,
    (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    json['avatar'] as String,
    json['access_token'] as String,
    json['refresh_token'] as String,
    json['expired'] as int,
  );
}

Map<String, dynamic> _$LoginRespDataToJson(LoginRespData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'branch': instance.branch,
      'roles': instance.roles,
      'avatar': instance.avatar,
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'expired': instance.expired,
    };
