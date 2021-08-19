// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'altai_virtual_list_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AltaiVirtualListResponse _$AltaiVirtualListResponseFromJson(
    Map<String, dynamic> json) {
  return AltaiVirtualListResponse(
    json['error'] == null
        ? null
        : ErrorResp.fromJson(json['error'] as Map<String, dynamic>),
    (json['data'] as List<dynamic>?)
            ?.map((e) =>
                AltaiVirtualMinResponse.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$AltaiVirtualListResponseToJson(
        AltaiVirtualListResponse instance) =>
    <String, dynamic>{
      'error': instance.error?.toJson(),
      'data': instance.data.map((e) => e.toJson()).toList(),
    };

AltaiVirtualMinResponse _$AltaiVirtualMinResponseFromJson(
    Map<String, dynamic> json) {
  return AltaiVirtualMinResponse(
    json['id'] as String,
    json['created_at'] as int,
    json['created_by'] as String,
    json['updated_at'] as int,
    json['updated_by'] as String,
    json['branch'] as String,
    json['time_started'] as int,
    json['time_ended'] as int,
    json['is_finish'] as bool,
    json['note'] as String,
  );
}

Map<String, dynamic> _$AltaiVirtualMinResponseToJson(
        AltaiVirtualMinResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'created_by': instance.createdBy,
      'updated_at': instance.updatedAt,
      'updated_by': instance.updatedBy,
      'branch': instance.branch,
      'time_started': instance.timeStarted,
      'time_ended': instance.timeEnded,
      'is_finish': instance.isFinish,
      'note': instance.note,
    };
