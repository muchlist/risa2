// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_maintenance_list_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MainMaintenanceListResponse _$MainMaintenanceListResponseFromJson(
    Map<String, dynamic> json) {
  return MainMaintenanceListResponse(
    json['error'] == null
        ? null
        : ErrorResp.fromJson(json['error'] as Map<String, dynamic>),
    (json['data'] as List<dynamic>?)
            ?.map(
                (e) => MainMaintMinResponse.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$MainMaintenanceListResponseToJson(
        MainMaintenanceListResponse instance) =>
    <String, dynamic>{
      'error': instance.error?.toJson(),
      'data': instance.data.map((e) => e.toJson()).toList(),
    };

MainMaintMinResponse _$MainMaintMinResponseFromJson(Map<String, dynamic> json) {
  return MainMaintMinResponse(
    json['id'] as String,
    json['quarterly_mode'] as bool,
    json['name'] as String,
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

Map<String, dynamic> _$MainMaintMinResponseToJson(
        MainMaintMinResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quarterly_mode': instance.quarterlyMode,
      'name': instance.name,
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
