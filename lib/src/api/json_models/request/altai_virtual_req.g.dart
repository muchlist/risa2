// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'altai_virtual_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AltaiVirtualUpdateRequest _$AltaiVirtualUpdateRequestFromJson(
    Map<String, dynamic> json) {
  return AltaiVirtualUpdateRequest(
    parentID: json['parent_id'] as String,
    childID: json['child_id'] as String,
    isChecked: json['is_checked'] as bool,
    isOffline: json['is_offline'] as bool,
  );
}

Map<String, dynamic> _$AltaiVirtualUpdateRequestToJson(
        AltaiVirtualUpdateRequest instance) =>
    <String, dynamic>{
      'parent_id': instance.parentID,
      'child_id': instance.childID,
      'is_checked': instance.isChecked,
      'is_offline': instance.isOffline,
    };

BulkVendorUpdateRequest _$BulkVendorUpdateRequestFromJson(
    Map<String, dynamic> json) {
  return BulkVendorUpdateRequest(
    (json['items'] as List<dynamic>)
        .map((e) =>
            AltaiVirtualUpdateRequest.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$BulkVendorUpdateRequestToJson(
        BulkVendorUpdateRequest instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
    };
