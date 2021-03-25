// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorResp _$ErrorRespFromJson(Map<String, dynamic> json) {
  return ErrorResp(
    json['status'] as int,
    json['message'] as String,
    json['error'] as String,
    (json['causes'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
  );
}

Map<String, dynamic> _$ErrorRespToJson(ErrorResp instance) => <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'error': instance.error,
      'causes': instance.causes,
    };
