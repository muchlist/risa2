// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_check_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VendorCheckDetailResponse _$VendorCheckDetailResponseFromJson(
    Map<String, dynamic> json) {
  return VendorCheckDetailResponse(
    json['error'] == null
        ? null
        : ErrorResp.fromJson(json['error'] as Map<String, dynamic>),
    json['data'] == null
        ? null
        : VendorCheckDetailResponseData.fromJson(
            json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$VendorCheckDetailResponseToJson(
        VendorCheckDetailResponse instance) =>
    <String, dynamic>{
      'error': instance.error?.toJson(),
      'data': instance.data?.toJson(),
    };

VendorCheckDetailResponseData _$VendorCheckDetailResponseDataFromJson(
    Map<String, dynamic> json) {
  return VendorCheckDetailResponseData(
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
    json['is_virtual_check'] as bool,
    json['is_finish'] as bool,
    json['note'] as String,
    (json['vendor_check_items'] as List<dynamic>?)
            ?.map((e) => VendorCheckItem.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$VendorCheckDetailResponseDataToJson(
        VendorCheckDetailResponseData instance) =>
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
      'is_virtual_check': instance.isVirtualCheck,
      'is_finish': instance.isFinish,
      'note': instance.note,
      'vendor_check_items':
          instance.vendorCheckItems.map((e) => e.toJson()).toList(),
    };

VendorCheckItem _$VendorCheckItemFromJson(Map<String, dynamic> json) {
  return VendorCheckItem(
    json['id'] as String,
    json['name'] as String,
    json['location'] as String,
    json['checked_at'] as int,
    json['checked_by'] as String,
    json['is_checked'] as bool,
    json['is_blur'] as bool,
    json['is_offline'] as bool,
    json['image_path'] as String,
  );
}

Map<String, dynamic> _$VendorCheckItemToJson(VendorCheckItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'location': instance.location,
      'checked_at': instance.checkedAt,
      'checked_by': instance.checkedBy,
      'is_checked': instance.isChecked,
      'is_blur': instance.isBlur,
      'is_offline': instance.isOffline,
      'image_path': instance.imagePath,
    };
