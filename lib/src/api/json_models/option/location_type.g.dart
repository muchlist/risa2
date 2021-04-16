// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OptLocationType _$OptLocationTypeFromJson(Map<String, dynamic> json) {
  return OptLocationType(
    (json['location'] as List<dynamic>?)?.map((e) => e as String).toList() ??
        [],
    (json['type'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
  );
}

Map<String, dynamic> _$OptLocationTypeToJson(OptLocationType instance) =>
    <String, dynamic>{
      'location': instance.location,
      'type': instance.type,
    };
