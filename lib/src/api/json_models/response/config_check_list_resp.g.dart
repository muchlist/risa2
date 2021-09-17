// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_check_list_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfigCheckListResponse _$ConfigCheckListResponseFromJson(
    Map<String, dynamic> json) {
  return ConfigCheckListResponse(
    json['error'] == null
        ? null
        : ErrorResp.fromJson(json['error'] as Map<String, dynamic>),
    (json['data'] as List<dynamic>?)
            ?.map((e) => ConfigCheckDetailResponseData.fromJson(
                e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$ConfigCheckListResponseToJson(
        ConfigCheckListResponse instance) =>
    <String, dynamic>{
      'error': instance.error?.toJson(),
      'data': instance.data.map((e) => e.toJson()).toList(),
    };
