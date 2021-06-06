// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'computer_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OptComputerType _$OptComputerTypeFromJson(Map<String, dynamic> json) {
  return OptComputerType(
    (json['location'] as List<dynamic>?)?.map((e) => e as String).toList() ??
        [],
    (json['division'] as List<dynamic>?)?.map((e) => e as String).toList() ??
        [],
    (json['os'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    (json['processor'] as List<dynamic>?)?.map((e) => e as String).toList() ??
        [],
    (json['hardisk'] as List<dynamic>?)?.map((e) => e as int).toList() ?? [],
    (json['ram'] as List<dynamic>?)?.map((e) => e as int).toList() ?? [],
    (json['type'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
  );
}

Map<String, dynamic> _$OptComputerTypeToJson(OptComputerType instance) =>
    <String, dynamic>{
      'location': instance.location,
      'division': instance.division,
      'os': instance.os,
      'processor': instance.processor,
      'hardisk': instance.hardisk,
      'ram': instance.ram,
      'type': instance.type,
    };
