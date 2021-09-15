// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_check_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfigCheckUpdateRequest _$ConfigCheckUpdateRequestFromJson(
    Map<String, dynamic> json) {
  return ConfigCheckUpdateRequest(
    parentID: json['parent_id'] as String,
    childID: json['child_id'] as String,
    isUpdated: json['is_updated'] as bool,
  );
}

Map<String, dynamic> _$ConfigCheckUpdateRequestToJson(
        ConfigCheckUpdateRequest instance) =>
    <String, dynamic>{
      'parent_id': instance.parentID,
      'child_id': instance.childID,
      'is_updated': instance.isUpdated,
    };
