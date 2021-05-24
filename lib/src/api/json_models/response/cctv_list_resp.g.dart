// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cctv_list_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CctvListResponse _$CctvListResponseFromJson(Map<String, dynamic> json) {
  return CctvListResponse(
    json['error'] == null
        ? null
        : ErrorResp.fromJson(json['error'] as Map<String, dynamic>),
    CctvListData.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CctvListResponseToJson(CctvListResponse instance) =>
    <String, dynamic>{
      'error': instance.error?.toJson(),
      'data': instance.data.toJson(),
    };

CctvListData _$CctvListDataFromJson(Map<String, dynamic> json) {
  return CctvListData(
    (json['cctv_list'] as List<dynamic>?)
            ?.map((e) => CctvMinResponse.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    (json['extra_list'] as List<dynamic>?)
            ?.map((e) => GeneralMinResponse.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$CctvListDataToJson(CctvListData instance) =>
    <String, dynamic>{
      'cctv_list': instance.cctvList.map((e) => e.toJson()).toList(),
      'extra_list': instance.extraList.map((e) => e.toJson()).toList(),
    };

CctvMinResponse _$CctvMinResponseFromJson(Map<String, dynamic> json) {
  return CctvMinResponse(
    json['id'] as String,
    json['branch'] as String,
    json['disable'] as bool,
    json['name'] as String,
    json['ip'] as String,
    json['location'] as String,
    (json['tag'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
  );
}

Map<String, dynamic> _$CctvMinResponseToJson(CctvMinResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'branch': instance.branch,
      'disable': instance.disable,
      'name': instance.name,
      'ip': instance.ip,
      'location': instance.location,
      'tag': instance.tag,
    };
