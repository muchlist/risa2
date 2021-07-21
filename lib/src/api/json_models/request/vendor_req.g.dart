// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VendorUpdateRequest _$VendorUpdateRequestFromJson(Map<String, dynamic> json) {
  return VendorUpdateRequest(
    parentID: json['parent_id'] as String,
    childID: json['child_id'] as String,
    isChecked: json['is_checked'] as bool,
    isBlur: json['is_blur'] as bool,
    isOffline: json['is_offline'] as bool,
  );
}

Map<String, dynamic> _$VendorUpdateRequestToJson(
        VendorUpdateRequest instance) =>
    <String, dynamic>{
      'parent_id': instance.parentID,
      'child_id': instance.childID,
      'is_checked': instance.isChecked,
      'is_blur': instance.isBlur,
      'is_offline': instance.isOffline,
    };
