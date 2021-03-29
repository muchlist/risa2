// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_list_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckListResponse _$CheckListResponseFromJson(Map<String, dynamic> json) {
  return CheckListResponse(
    json['error'] == null
        ? null
        : ErrorResp.fromJson(json['error'] as Map<String, dynamic>),
    (json['data'] as List<dynamic>?)
            ?.map((e) => CheckMinResponse.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$CheckListResponseToJson(CheckListResponse instance) =>
    <String, dynamic>{
      'error': instance.error?.toJson(),
      'data': instance.data.map((e) => e.toJson()).toList(),
    };

CheckMinResponse _$CheckMinResponseFromJson(Map<String, dynamic> json) {
  return CheckMinResponse(
    json['id'] as String,
    json['created_at'] as int,
    json['created_by'] as String,
    json['updated_at'] as int,
    json['branch'] as String,
    json['shift'] as int,
    json['is_finish'] as bool,
    json['note'] as String,
  );
}

Map<String, dynamic> _$CheckMinResponseToJson(CheckMinResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'created_by': instance.createdBy,
      'updated_at': instance.updatedAt,
      'branch': instance.branch,
      'shift': instance.shift,
      'is_finish': instance.isFinish,
      'note': instance.note,
    };
