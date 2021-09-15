// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_check_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfigCheckDetailResponse _$ConfigCheckDetailResponseFromJson(
    Map<String, dynamic> json) {
  return ConfigCheckDetailResponse(
    json['error'] == null
        ? null
        : ErrorResp.fromJson(json['error'] as Map<String, dynamic>),
    json['data'] == null
        ? null
        : ConfigCheckDetailResponseData.fromJson(
            json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ConfigCheckDetailResponseToJson(
        ConfigCheckDetailResponse instance) =>
    <String, dynamic>{
      'error': instance.error?.toJson(),
      'data': instance.data?.toJson(),
    };

ConfigCheckDetailResponseData _$ConfigCheckDetailResponseDataFromJson(
    Map<String, dynamic> json) {
  return ConfigCheckDetailResponseData(
    json['id'] as String,
    json['created_at'] as int,
    json['created_by'] as String,
    json['created_by_id'] as String,
    json['updated_at'] as int,
    json['updated_by'] as String,
    json['updated_by_id'] as String,
    json['branch'] as String,
    json['time_started'] as int,
    json['time_ended'] as int,
    json['is_finish'] as bool,
    json['note'] as String,
    (json['config_check_items'] as List<dynamic>?)
            ?.map((e) => ConfigCheckItem.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$ConfigCheckDetailResponseDataToJson(
        ConfigCheckDetailResponseData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'created_by': instance.createdBy,
      'created_by_id': instance.createdById,
      'updated_at': instance.updatedAt,
      'updated_by': instance.updatedBy,
      'updated_by_id': instance.updatedById,
      'branch': instance.branch,
      'time_started': instance.timeStarted,
      'time_ended': instance.timeEnded,
      'is_finish': instance.isFinish,
      'note': instance.note,
      'config_check_items':
          instance.configCheckItems.map((e) => e.toJson()).toList(),
    };

ConfigCheckItem _$ConfigCheckItemFromJson(Map<String, dynamic> json) {
  return ConfigCheckItem(
    json['id'] as String,
    json['name'] as String,
    json['location'] as String,
    json['checked_at'] as int,
    json['checked_by'] as String,
    json['is_updated'] as bool,
  );
}

Map<String, dynamic> _$ConfigCheckItemToJson(ConfigCheckItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'location': instance.location,
      'checked_at': instance.checkedAt,
      'checked_by': instance.checkedBy,
      'is_updated': instance.isUpdated,
    };
