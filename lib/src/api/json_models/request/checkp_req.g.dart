// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkp_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckpRequest _$CheckpRequestFromJson(Map<String, dynamic> json) {
  return CheckpRequest(
    name: json['name'] as String,
    location: json['location'] as String,
    note: json['note'] as String,
    shifts:
        (json['shifts'] as List<dynamic>?)?.map((e) => e as int).toList() ?? [],
    type: json['type'] as String,
    tag:
        (json['tag'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    tagExtra: (json['tag_extra'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$CheckpRequestToJson(CheckpRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'location': instance.location,
      'note': instance.note,
      'shifts': instance.shifts,
      'type': instance.type,
      'tag': instance.tag,
      'tag_extra': instance.tagExtra,
    };
