// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckDetailResponse _$CheckDetailResponseFromJson(Map<String, dynamic> json) {
  return CheckDetailResponse(
    json['error'] == null
        ? null
        : ErrorResp.fromJson(json['error'] as Map<String, dynamic>),
    json['data'] == null
        ? null
        : CheckDetailResponseData.fromJson(
            json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CheckDetailResponseToJson(
        CheckDetailResponse instance) =>
    <String, dynamic>{
      'error': instance.error?.toJson(),
      'data': instance.data?.toJson(),
    };

CheckDetailResponseData _$CheckDetailResponseDataFromJson(
    Map<String, dynamic> json) {
  return CheckDetailResponseData(
    json['id'] as String,
    json['created_at'] as int,
    json['updated_at'] as int,
    json['created_by'] as String,
    json['created_by_id'] as String,
    json['updated_by'] as String,
    json['updated_by_id'] as String,
    json['branch'] as String,
    json['shift'] as int,
    json['is_finish'] as bool,
    json['note'] as String,
    (json['check_items'] as List<dynamic>?)
            ?.map((e) => CheckItem.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$CheckDetailResponseDataToJson(
        CheckDetailResponseData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'created_by': instance.createdBy,
      'created_by_id': instance.createdById,
      'updated_by': instance.updatedBy,
      'updated_by_id': instance.updatedById,
      'branch': instance.branch,
      'shift': instance.shift,
      'is_finish': instance.isFinish,
      'note': instance.note,
      'check_items': instance.checkItems.map((e) => e.toJson()).toList(),
    };

CheckItem _$CheckItemFromJson(Map<String, dynamic> json) {
  return CheckItem(
    json['id'] as String,
    json['name'] as String,
    json['location'] as String,
    json['type'] as String,
    (json['tag'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    (json['tag_extra'] as List<dynamic>?)?.map((e) => e as String).toList() ??
        [],
    json['checked_at'] as int,
    json['tag_selected'] as String,
    json['tag_extra_selected'] as String,
    json['image_path'] as String,
    json['checked_note'] as String,
    json['have_problem'] as bool,
    json['complete_status'] as int,
  );
}

Map<String, dynamic> _$CheckItemToJson(CheckItem instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'location': instance.location,
      'type': instance.type,
      'tag': instance.tag,
      'tag_extra': instance.tagExtra,
      'checked_at': instance.checkedAt,
      'tag_selected': instance.tagSelected,
      'tag_extra_selected': instance.tagExtraSelected,
      'image_path': instance.imagePath,
      'checked_note': instance.checkedNote,
      'have_problem': instance.haveProblem,
      'complete_status': instance.completeStatus,
    };
