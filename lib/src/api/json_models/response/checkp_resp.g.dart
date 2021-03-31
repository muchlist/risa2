// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkp_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckpDetailResponse _$CheckpDetailResponseFromJson(Map<String, dynamic> json) {
  return CheckpDetailResponse(
    json['error'] == null
        ? null
        : ErrorResp.fromJson(json['error'] as Map<String, dynamic>),
    json['data'] == null
        ? null
        : CheckpDetailResponseData.fromJson(
            json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CheckpDetailResponseToJson(
        CheckpDetailResponse instance) =>
    <String, dynamic>{
      'error': instance.error?.toJson(),
      'data': instance.data?.toJson(),
    };

CheckpDetailResponseData _$CheckpDetailResponseDataFromJson(
    Map<String, dynamic> json) {
  return CheckpDetailResponseData(
    json['id'] as String,
    json['created_at'] as int,
    json['updated_at'] as int,
    json['created_by'] as String,
    json['created_by_id'] as String,
    json['updated_by'] as String,
    json['updated_by_id'] as String,
    json['branch'] as String,
    json['disable'] as bool,
    json['name'] as String,
    json['location'] as String,
    json['location_lat'] as String,
    json['location_lon'] as String,
    json['type'] as String,
    (json['tag'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    (json['tagExtra'] as List<dynamic>?)?.map((e) => e as String).toList() ??
        [],
    json['note'] as String,
    (json['shifts'] as List<dynamic>?)?.map((e) => e as int).toList() ?? [],
    json['checked_note'] as String,
    json['have_problem'] as bool,
    json['complete_status'] as int,
  );
}

Map<String, dynamic> _$CheckpDetailResponseDataToJson(
        CheckpDetailResponseData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'created_by': instance.createdBy,
      'created_by_id': instance.createdById,
      'updated_by': instance.updatedBy,
      'updated_by_id': instance.updatedById,
      'branch': instance.branch,
      'disable': instance.disable,
      'name': instance.name,
      'location': instance.location,
      'location_lat': instance.locationLat,
      'location_lon': instance.locationLon,
      'type': instance.type,
      'tag': instance.tag,
      'tagExtra': instance.tagExtra,
      'note': instance.note,
      'shifts': instance.shifts,
      'checked_note': instance.checkedNote,
      'have_problem': instance.haveProblem,
      'complete_status': instance.completeStatus,
    };
