// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_edit_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckEditRequest _$CheckEditRequestFromJson(Map<String, dynamic> json) {
  return CheckEditRequest(
    isFinish: json['is_finish'] as bool,
    note: json['note'] as String,
  );
}

Map<String, dynamic> _$CheckEditRequestToJson(CheckEditRequest instance) =>
    <String, dynamic>{
      'is_finish': instance.isFinish,
      'note': instance.note,
    };
