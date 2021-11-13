// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ba_add_participant_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaAddParticipantRequest _$BaAddParticipantRequestFromJson(
    Map<String, dynamic> json) {
  return BaAddParticipantRequest(
    userId: json['user_id'] as String,
    alias: json['alias'] as String,
  );
}

Map<String, dynamic> _$BaAddParticipantRequestToJson(
        BaAddParticipantRequest instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'alias': instance.alias,
    };
