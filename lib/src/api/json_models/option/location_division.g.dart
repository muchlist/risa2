// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_division.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OptLocationDivison _$OptLocationDivisonFromJson(Map<String, dynamic> json) {
  return OptLocationDivison(
    (json['location'] as List<dynamic>?)?.map((e) => e as String).toList() ??
        [],
    (json['division'] as List<dynamic>?)?.map((e) => e as String).toList() ??
        [],
  );
}

Map<String, dynamic> _$OptLocationDivisonToJson(OptLocationDivison instance) =>
    <String, dynamic>{
      'location': instance.location,
      'division': instance.division,
    };
