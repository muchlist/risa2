// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'other_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtherDetailResponse _$OtherDetailResponseFromJson(Map<String, dynamic> json) {
  return OtherDetailResponse(
    json['error'] == null
        ? null
        : ErrorResp.fromJson(json['error'] as Map<String, dynamic>),
    json['data'] == null
        ? null
        : OtherDetailResponseData.fromJson(
            json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$OtherDetailResponseToJson(
        OtherDetailResponse instance) =>
    <String, dynamic>{
      'error': instance.error?.toJson(),
      'data': instance.data?.toJson(),
    };

OtherDetailResponseData _$OtherDetailResponseDataFromJson(
    Map<String, dynamic> json) {
  return OtherDetailResponseData(
    json['sub_category'] as String,
    json['id'] as String,
    json['created_at'] as int,
    json['updated_at'] as int,
    json['created_by'] as String,
    json['created_by_id'] as String,
    json['updated_by'] as String,
    json['updated_by_id'] as String,
    json['branch'] as String,
    json['disable'] as bool,
    json['name'] as String,
    json['detail'] as String,
    json['ip'] as String,
    json['inventory_number'] as String,
    json['location'] as String,
    json['location_lat'] as String,
    json['location_lon'] as String,
    json['division'] as String,
    json['date'] as int,
    (json['tag'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    json['image'] as String,
    json['brand'] as String,
    json['type'] as String,
    json['note'] as String,
    OtherExtra.fromJson(json['extra'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$OtherDetailResponseDataToJson(
        OtherDetailResponseData instance) =>
    <String, dynamic>{
      'sub_category': instance.subCategory,
      'id': instance.id,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'created_by': instance.createdBy,
      'created_by_id': instance.createdById,
      'updated_by': instance.updatedBy,
      'updated_by_id': instance.updatedById,
      'branch': instance.branch,
      'disable': instance.disable,
      'name': instance.name,
      'detail': instance.detail,
      'ip': instance.ip,
      'inventory_number': instance.inventoryNumber,
      'location': instance.location,
      'location_lat': instance.locationLat,
      'location_lon': instance.locationLon,
      'division': instance.division,
      'date': instance.date,
      'tag': instance.tag,
      'image': instance.image,
      'brand': instance.brand,
      'type': instance.type,
      'note': instance.note,
      'extra': instance.extra.toJson(),
    };

OtherExtra _$OtherExtraFromJson(Map<String, dynamic> json) {
  return OtherExtra(
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

Map<String, dynamic> _$OtherExtraToJson(OtherExtra instance) =>
    <String, dynamic>{
      'cases': instance.cases.map((e) => e.toJson()).toList(),
      'cases_size': instance.casesSize,
      'pings_state': instance.pingsState.map((e) => e.toJson()).toList(),
      'last_ping': instance.lastPing,
    };
