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

ConfigCheckUpdateManyRequest _$ConfigCheckUpdateManyRequestFromJson(
    Map<String, dynamic> json) {
  return ConfigCheckUpdateManyRequest(
    parentID: json['parent_id'] as String,
    childUpdate: (json['child_update'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    childNotUpdate: (json['child_not_updated'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
  );
}

Map<String, dynamic> _$ConfigCheckUpdateManyRequestToJson(
        ConfigCheckUpdateManyRequest instance) =>
    <String, dynamic>{
      'parent_id': instance.parentID,
      'child_update': instance.childUpdate,
      'child_not_updated': instance.childNotUpdate,
    };
