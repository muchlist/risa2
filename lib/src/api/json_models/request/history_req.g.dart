// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryRequest _$HistoryRequestFromJson(Map<String, dynamic> json) {
  return HistoryRequest(
    id: json['id'] as String,
    parentID: json['parent_id'] as String,
    problem: json['problem'] as String,
    problemResolve: json['problem_resolve'] as String,
    status: json['status'] as String,
    tag:
        (json['tag'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    completeStatus: json['complete_status'] as int,
    image: json['image'] as String,
  );
}

Map<String, dynamic> _$HistoryRequestToJson(HistoryRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parent_id': instance.parentID,
      'problem': instance.problem,
      'problem_resolve': instance.problemResolve,
      'status': instance.status,
      'tag': instance.tag,
      'complete_status': instance.completeStatus,
      'image': instance.image,
    };
