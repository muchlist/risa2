// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'improve_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImproveDetailResponse _$ImproveDetailResponseFromJson(
    Map<String, dynamic> json) {
  return ImproveDetailResponse(
    json['error'] == null
        ? null
        : ErrorResp.fromJson(json['error'] as Map<String, dynamic>),
    json['data'] == null
        ? null
        : ImproveDetailResponseData.fromJson(
            json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ImproveDetailResponseToJson(
        ImproveDetailResponse instance) =>
    <String, dynamic>{
      'error': instance.error?.toJson(),
      'data': instance.data?.toJson(),
    };

ImproveDetailResponseData _$ImproveDetailResponseDataFromJson(
    Map<String, dynamic> json) {
  return ImproveDetailResponseData(
    json['id'] as String,
    json['created_at'] as int,
    json['updated_at'] as int,
    json['created_by'] as String,
    json['created_by_id'] as String,
    json['updated_by'] as String,
    json['updated_by_id'] as String,
    json['branch'] as String,
    json['title'] as String,
    json['description'] as String,
    json['goal'] as int,
    json['goals_achieved'] as int,
    json['is_active'] as bool,
    json['complete_status'] as int,
    (json['improve_changes'] as List<dynamic>?)
            ?.map((e) => ImproveChange.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$ImproveDetailResponseDataToJson(
        ImproveDetailResponseData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'created_by': instance.createdBy,
      'created_by_id': instance.createdById,
      'updated_by': instance.updatedBy,
      'updated_by_id': instance.updatedById,
      'branch': instance.branch,
      'title': instance.title,
      'description': instance.description,
      'goal': instance.goal,
      'goals_achieved': instance.goalsAchieved,
      'is_active': instance.isActive,
      'complete_status': instance.completeStatus,
      'improve_changes':
          instance.improveChanges.map((e) => e.toJson()).toList(),
    };

ImproveChange _$ImproveChangeFromJson(Map<String, dynamic> json) {
  return ImproveChange(
    json['dummy_id'] as int,
    json['author'] as String,
    json['increment'] as int,
    json['note'] as String,
    json['time'] as int,
  );
}

Map<String, dynamic> _$ImproveChangeToJson(ImproveChange instance) =>
    <String, dynamic>{
      'dummy_id': instance.dummyId,
      'author': instance.author,
      'increment': instance.increment,
      'note': instance.note,
      'time': instance.time,
    };
