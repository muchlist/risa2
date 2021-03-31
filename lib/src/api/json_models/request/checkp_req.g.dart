// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkp_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckpRequest _$CheckpRequestFromJson(Map<String, dynamic> json) {
  return CheckpRequest(
    json['name'] as String,
    json['location'] as String,
    json['note'] as String,
    (json['shifts'] as List<dynamic>?)?.map((e) => e as int).toList() ?? [],
    json['type'] as String,
    (json['tag_one'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    (json['tag_two'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
  );
}

Map<String, dynamic> _$CheckpRequestToJson(CheckpRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'location': instance.location,
      'note': instance.note,
      'shifts': instance.shifts,
      'type': instance.type,
      'tag_one': instance.tagOne,
      'tag_two': instance.tagTwo,
    };
