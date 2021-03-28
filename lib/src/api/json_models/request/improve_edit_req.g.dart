// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'improve_edit_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImproveEditRequest _$ImproveEditRequestFromJson(Map<String, dynamic> json) {
  return ImproveEditRequest(
    filterTimestamp: json['filter_timestamp'] as int,
    title: json['title'] as String,
    description: json['description'] as String,
    goal: json['goal'] as int,
    completeStatus: json['complete_status'] as int,
  );
}

Map<String, dynamic> _$ImproveEditRequestToJson(ImproveEditRequest instance) =>
    <String, dynamic>{
      'filter_timestamp': instance.filterTimestamp,
      'title': instance.title,
      'description': instance.description,
      'goal': instance.goal,
      'complete_status': instance.completeStatus,
    };
