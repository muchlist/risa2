// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cctv_maintenance_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CCTVMaintUpdateRequest _$CCTVMaintUpdateRequestFromJson(
    Map<String, dynamic> json) {
  return CCTVMaintUpdateRequest(
    parentID: json['parent_id'] as String,
    childID: json['child_id'] as String,
    isChecked: json['is_checked'] as bool,
    isMaintained: json['is_maintained'] as bool,
    isBlur: json['is_blur'] as bool,
    isOffline: json['is_offline'] as bool,
  );
}

Map<String, dynamic> _$CCTVMaintUpdateRequestToJson(
        CCTVMaintUpdateRequest instance) =>
    <String, dynamic>{
      'parent_id': instance.parentID,
      'child_id': instance.childID,
      'is_checked': instance.isChecked,
      'is_maintained': instance.isMaintained,
      'is_blur': instance.isBlur,
      'is_offline': instance.isOffline,
    };

BulkCCTVMaintUpdateRequest _$BulkCCTVMaintUpdateRequestFromJson(
    Map<String, dynamic> json) {
  return BulkCCTVMaintUpdateRequest(
    (json['items'] as List<dynamic>)
        .map((e) => CCTVMaintUpdateRequest.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$BulkCCTVMaintUpdateRequestToJson(
        BulkCCTVMaintUpdateRequest instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
    };
