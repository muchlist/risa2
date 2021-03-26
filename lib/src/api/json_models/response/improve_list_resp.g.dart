// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'improve_list_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImproveListResponse _$ImproveListResponseFromJson(Map<String, dynamic> json) {
  return ImproveListResponse(
    json['error'] == null
        ? null
        : ErrorResp.fromJson(json['error'] as Map<String, dynamic>),
    (json['data'] as List<dynamic>?)
            ?.map((e) =>
                ImproveMinResponseData.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$ImproveListResponseToJson(
        ImproveListResponse instance) =>
    <String, dynamic>{
      'error': instance.error?.toJson(),
      'data': instance.data.map((e) => e.toJson()).toList(),
    };

ImproveMinResponseData _$ImproveMinResponseDataFromJson(
    Map<String, dynamic> json) {
  return ImproveMinResponseData(
    json['id'] as String,
    json['created_at'] as int,
    json['updated_at'] as int,
    json['branch'] as String,
    json['title'] as String,
    json['description'] as String,
    json['goal'] as int,
    json['goals_achieved'] as int,
    json['is_active'] as bool,
    json['complete_status'] as int,
  );
}

Map<String, dynamic> _$ImproveMinResponseDataToJson(
        ImproveMinResponseData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'branch': instance.branch,
      'title': instance.title,
      'description': instance.description,
      'goal': instance.goal,
      'goals_achieved': instance.goalsAchieved,
      'is_active': instance.isActive,
      'complete_status': instance.completeStatus,
    };
