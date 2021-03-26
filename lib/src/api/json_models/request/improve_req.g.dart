// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'improve_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImproveRequest _$ImproveRequestFromJson(Map<String, dynamic> json) {
  return ImproveRequest(
    title: json['title'] as String,
    description: json['description'] as String,
    goal: json['goal'] as int,
    completeStatus: json['complete_status'] as int,
  );
}

Map<String, dynamic> _$ImproveRequestToJson(ImproveRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'goal': instance.goal,
      'complete_status': instance.completeStatus,
    };
