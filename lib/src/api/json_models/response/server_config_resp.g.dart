// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_config_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerConfigDetailResponse _$ServerConfigDetailResponseFromJson(
    Map<String, dynamic> json) {
  return ServerConfigDetailResponse(
    json['error'] == null
        ? null
        : ErrorResp.fromJson(json['error'] as Map<String, dynamic>),
    json['data'] == null
        ? null
        : ServerConfigResponse.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ServerConfigDetailResponseToJson(
        ServerConfigDetailResponse instance) =>
    <String, dynamic>{
      'error': instance.error?.toJson(),
      'data': instance.data?.toJson(),
    };

ServerConfigResponse _$ServerConfigResponseFromJson(Map<String, dynamic> json) {
  return ServerConfigResponse(
    json['id'] as String,
    json['updated_by'] as String,
    json['updated_at'] as int,
    json['branch'] as String,
    json['title'] as String,
    json['note'] as String,
    json['diff'] as String,
    json['image'] as String,
  );
}

Map<String, dynamic> _$ServerConfigResponseToJson(
        ServerConfigResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'updated_by': instance.updatedBy,
      'updated_at': instance.updatedAt,
      'branch': instance.branch,
      'title': instance.title,
      'note': instance.note,
      'diff': instance.diff,
      'image': instance.image,
    };
