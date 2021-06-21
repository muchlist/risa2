// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speed_list_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpeedListResponse _$SpeedListResponseFromJson(Map<String, dynamic> json) {
  return SpeedListResponse(
    json['error'] == null
        ? null
        : ErrorResp.fromJson(json['error'] as Map<String, dynamic>),
    (json['data'] as List<dynamic>?)
            ?.map((e) => SpeedData.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$SpeedListResponseToJson(SpeedListResponse instance) =>
    <String, dynamic>{
      'error': instance.error?.toJson(),
      'data': instance.data.map((e) => e.toJson()).toList(),
    };

SpeedData _$SpeedDataFromJson(Map<String, dynamic> json) {
  return SpeedData(
    json['time'] as int,
    json['latency_ms'] as int,
    (json['upload'] as num).toDouble(),
    (json['download'] as num).toDouble(),
  );
}

Map<String, dynamic> _$SpeedDataToJson(SpeedData instance) => <String, dynamic>{
      'time': instance.time,
      'latency_ms': instance.latencyMs,
      'upload': instance.upload,
      'download': instance.download,
    };
