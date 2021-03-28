// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'general_list_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeneralListResponse _$GeneralListResponseFromJson(Map<String, dynamic> json) {
  return GeneralListResponse(
    json['error'] == null
        ? null
        : ErrorResp.fromJson(json['error'] as Map<String, dynamic>),
    (json['data'] as List<dynamic>?)
            ?.map((e) => GeneralMinResponse.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$GeneralListResponseToJson(
        GeneralListResponse instance) =>
    <String, dynamic>{
      'error': instance.error?.toJson(),
      'data': instance.data.map((e) => e.toJson()).toList(),
    };

GeneralMinResponse _$GeneralMinResponseFromJson(Map<String, dynamic> json) {
  return GeneralMinResponse(
    json['id'] as String,
    json['category'] as String,
    json['name'] as String,
    json['ip'] as String,
    json['branch'] as String,
    (json['cases'] as List<dynamic>?)
            ?.map((e) => Case.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    json['cases_size'] as int,
    (json['pings_state'] as List<dynamic>?)
            ?.map((e) => PingState.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    json['last_ping'] as String,
  );
}

Map<String, dynamic> _$GeneralMinResponseToJson(GeneralMinResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': instance.category,
      'name': instance.name,
      'ip': instance.ip,
      'branch': instance.branch,
      'cases': instance.cases.map((e) => e.toJson()).toList(),
      'cases_size': instance.casesSize,
      'pings_state': instance.pingsState.map((e) => e.toJson()).toList(),
      'last_ping': instance.lastPing,
    };

PingState _$PingStateFromJson(Map<String, dynamic> json) {
  return PingState(
    json['code'] as int,
    json['time'] as int,
    json['status'] as String,
  );
}

Map<String, dynamic> _$PingStateToJson(PingState instance) => <String, dynamic>{
      'code': instance.code,
      'time': instance.time,
      'status': instance.status,
    };

Case _$CaseFromJson(Map<String, dynamic> json) {
  return Case(
    json['case_id'] as String,
    json['case_note'] as String,
  );
}

Map<String, dynamic> _$CaseToJson(Case instance) => <String, dynamic>{
      'case_id': instance.caseId,
      'case_note': instance.caseNote,
    };
