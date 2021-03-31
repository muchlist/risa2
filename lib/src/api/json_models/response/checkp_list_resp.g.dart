// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkp_list_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckpListResponse _$CheckpListResponseFromJson(Map<String, dynamic> json) {
  return CheckpListResponse(
    json['error'] == null
        ? null
        : ErrorResp.fromJson(json['error'] as Map<String, dynamic>),
    (json['data'] as List<dynamic>?)
            ?.map((e) => CheckpMinResponse.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$CheckpListResponseToJson(CheckpListResponse instance) =>
    <String, dynamic>{
      'error': instance.error?.toJson(),
      'data': instance.data.map((e) => e.toJson()).toList(),
    };

CheckpMinResponse _$CheckpMinResponseFromJson(Map<String, dynamic> json) {
  return CheckpMinResponse(
    json['id'] as String,
    json['branch'] as String,
    json['disable'] as bool,
    json['name'] as String,
    json['location'] as String,
    json['type'] as String,
    json['note'] as String,
    (json['shifts'] as List<dynamic>?)?.map((e) => e as int).toList() ?? [],
    (json['tag'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    (json['tagExtra'] as List<dynamic>?)?.map((e) => e as String).toList() ??
        [],
    json['checked_note'] as String,
    json['have_problem'] as bool,
    json['complete_status'] as int,
  );
}

Map<String, dynamic> _$CheckpMinResponseToJson(CheckpMinResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'branch': instance.branch,
      'disable': instance.disable,
      'name': instance.name,
      'location': instance.location,
      'type': instance.type,
      'note': instance.note,
      'shifts': instance.shifts,
      'tag': instance.tag,
      'tagExtra': instance.tagExtra,
      'checked_note': instance.checkedNote,
      'have_problem': instance.haveProblem,
      'complete_status': instance.completeStatus,
    };
