// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'other_list_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtherListResponse _$OtherListResponseFromJson(Map<String, dynamic> json) {
  return OtherListResponse(
    json['error'] == null
        ? null
        : ErrorResp.fromJson(json['error'] as Map<String, dynamic>),
    OtherListData.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$OtherListResponseToJson(OtherListResponse instance) =>
    <String, dynamic>{
      'error': instance.error?.toJson(),
      'data': instance.data.toJson(),
    };

OtherListData _$OtherListDataFromJson(Map<String, dynamic> json) {
  return OtherListData(
    (json['other_list'] as List<dynamic>?)
            ?.map((e) => OtherMinResponse.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    (json['extra_list'] as List<dynamic>?)
            ?.map((e) => GeneralMinResponse.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$OtherListDataToJson(OtherListData instance) =>
    <String, dynamic>{
      'other_list': instance.otherList.map((e) => e.toJson()).toList(),
      'extra_list': instance.extraList.map((e) => e.toJson()).toList(),
    };

OtherMinResponse _$OtherMinResponseFromJson(Map<String, dynamic> json) {
  return OtherMinResponse(
    json['sub_category'] as String,
    json['id'] as String,
    json['branch'] as String,
    json['disable'] as bool,
    json['name'] as String,
    json['detail'] as String,
    json['division'] as String,
    json['ip'] as String,
    json['location'] as String,
    (json['tag'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
  );
}

Map<String, dynamic> _$OtherMinResponseToJson(OtherMinResponse instance) =>
    <String, dynamic>{
      'sub_category': instance.subCategory,
      'id': instance.id,
      'branch': instance.branch,
      'disable': instance.disable,
      'name': instance.name,
      'detail': instance.detail,
      'division': instance.division,
      'ip': instance.ip,
      'location': instance.location,
      'tag': instance.tag,
    };
