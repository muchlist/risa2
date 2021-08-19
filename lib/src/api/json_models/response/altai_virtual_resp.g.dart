// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'altai_virtual_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AltaiVirtualDetailResponse _$AltaiVirtualDetailResponseFromJson(
    Map<String, dynamic> json) {
  return AltaiVirtualDetailResponse(
    json['error'] == null
        ? null
        : ErrorResp.fromJson(json['error'] as Map<String, dynamic>),
    json['data'] == null
        ? null
        : AltaiVirtualDetailResponseData.fromJson(
            json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$AltaiVirtualDetailResponseToJson(
        AltaiVirtualDetailResponse instance) =>
    <String, dynamic>{
      'error': instance.error?.toJson(),
      'data': instance.data?.toJson(),
    };

AltaiVirtualDetailResponseData _$AltaiVirtualDetailResponseDataFromJson(
    Map<String, dynamic> json) {
  return AltaiVirtualDetailResponseData(
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
    (json['altai_check_items'] as List<dynamic>?)
            ?.map((e) => AltaiCheckItem.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$AltaiVirtualDetailResponseDataToJson(
        AltaiVirtualDetailResponseData instance) =>
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
      'altai_check_items':
          instance.altaiCheckItems.map((e) => e.toJson()).toList(),
    };

AltaiCheckItem _$AltaiCheckItemFromJson(Map<String, dynamic> json) {
  return AltaiCheckItem(
    json['id'] as String,
    json['name'] as String,
    json['location'] as String,
    json['checked_at'] as int,
    json['checked_by'] as String,
    json['is_checked'] as bool,
    json['is_offline'] as bool,
    json['image_path'] as String,
  );
}

Map<String, dynamic> _$AltaiCheckItemToJson(AltaiCheckItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'location': instance.location,
      'checked_at': instance.checkedAt,
      'checked_by': instance.checkedBy,
      'is_checked': instance.isChecked,
      'is_offline': instance.isOffline,
      'image_path': instance.imagePath,
    };
