// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkp_edit_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckpEditRequest _$CheckpEditRequestFromJson(Map<String, dynamic> json) {
  return CheckpEditRequest(
    filterTimestamp: json['filter_timestamp'] as int,
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

Map<String, dynamic> _$CheckpEditRequestToJson(CheckpEditRequest instance) =>
    <String, dynamic>{
      'filter_timestamp': instance.filterTimestamp,
      'name': instance.name,
      'location': instance.location,
      'note': instance.note,
      'shifts': instance.shifts,
      'type': instance.type,
      'tag': instance.tag,
      'tag_extra': instance.tagExtra,
    };
