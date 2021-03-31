// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryDetailResponse _$HistoryDetailResponseFromJson(
    Map<String, dynamic> json) {
  return HistoryDetailResponse(
    json['error'] == null
        ? null
        : ErrorResp.fromJson(json['error'] as Map<String, dynamic>),
    json['data'] == null
        ? null
        : HistoryDetailResponseData.fromJson(
            json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$HistoryDetailResponseToJson(
        HistoryDetailResponse instance) =>
    <String, dynamic>{
      'error': instance.error?.toJson(),
      'data': instance.data?.toJson(),
    };

HistoryDetailResponseData _$HistoryDetailResponseDataFromJson(
    Map<String, dynamic> json) {
  return HistoryDetailResponseData(
    json['id'] as String,
    json['created_at'] as int,
    json['updated_at'] as int,
    json['created_by'] as String,
    json['updated_by'] as String,
    json['category'] as String,
    json['branch'] as String,
    json['parent_id'] as String,
    json['parent_name'] as String,
    json['status'] as String,
    json['problem'] as String,
    json['problem_resolve'] as String,
    json['complete_status'] as int,
    json['date_start'] as int,
    json['date_end'] as int,
    (json['tag'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    json['image'] as String,
  );
}

Map<String, dynamic> _$HistoryDetailResponseDataToJson(
        HistoryDetailResponseData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'created_by': instance.createdBy,
      'updated_by': instance.updatedBy,
      'category': instance.category,
      'branch': instance.branch,
      'parent_id': instance.parentID,
      'parent_name': instance.parentName,
      'status': instance.status,
      'problem': instance.problem,
      'problem_resolve': instance.problemResolve,
      'complete_status': instance.completeStatus,
      'date_start': instance.dateStart,
      'date_end': instance.dateEnd,
      'tag': instance.tag,
      'image': instance.image,
    };
