// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_config_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerConfigRequest _$ServerConfigRequestFromJson(Map<String, dynamic> json) {
  return ServerConfigRequest(
    title: json['title'] as String,
    note: json['note'] as String,
    diff: json['diff'] as String,
    image: json['image'] as String,
  );
}

Map<String, dynamic> _$ServerConfigRequestToJson(
        ServerConfigRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'note': instance.note,
      'diff': instance.diff,
      'image': instance.image,
    };
