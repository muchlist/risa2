// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_config_list_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerConfigListResponse _$ServerConfigListResponseFromJson(
    Map<String, dynamic> json) {
  return ServerConfigListResponse(
    json['error'] == null
        ? null
        : ErrorResp.fromJson(json['error'] as Map<String, dynamic>),
    (json['data'] as List<dynamic>?)
            ?.map(
                (e) => ServerConfigResponse.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$ServerConfigListResponseToJson(
        ServerConfigListResponse instance) =>
    <String, dynamic>{
      'error': instance.error?.toJson(),
      'data': instance.data.map((e) => e.toJson()).toList(),
    };
