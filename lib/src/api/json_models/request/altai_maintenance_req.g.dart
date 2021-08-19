// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'altai_maintenance_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AltaiMaintUpdateRequest _$AltaiMaintUpdateRequestFromJson(
    Map<String, dynamic> json) {
  return AltaiMaintUpdateRequest(
    parentID: json['parent_id'] as String,
    childID: json['child_id'] as String,
    isChecked: json['is_checked'] as bool,
    isMaintained: json['is_maintained'] as bool,
    isOffline: json['is_offline'] as bool,
  );
}

Map<String, dynamic> _$AltaiMaintUpdateRequestToJson(
        AltaiMaintUpdateRequest instance) =>
    <String, dynamic>{
      'parent_id': instance.parentID,
      'child_id': instance.childID,
      'is_checked': instance.isChecked,
      'is_maintained': instance.isMaintained,
      'is_offline': instance.isOffline,
    };

BulkAltaiMaintUpdateRequest _$BulkAltaiMaintUpdateRequestFromJson(
    Map<String, dynamic> json) {
  return BulkAltaiMaintUpdateRequest(
    (json['items'] as List<dynamic>)
        .map((e) => AltaiMaintUpdateRequest.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$BulkAltaiMaintUpdateRequestToJson(
        BulkAltaiMaintUpdateRequest instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
    };
