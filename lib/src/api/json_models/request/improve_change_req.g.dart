// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'improve_change_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImproveChangeRequest _$ImproveChangeRequestFromJson(Map<String, dynamic> json) {
  return ImproveChangeRequest(
    increment: json['increment'] as int,
    note: json['note'] as String,
    time: json['time'] as int,
  );
}

Map<String, dynamic> _$ImproveChangeRequestToJson(
        ImproveChangeRequest instance) =>
    <String, dynamic>{
      'increment': instance.increment,
      'note': instance.note,
      'time': instance.time,
    };
