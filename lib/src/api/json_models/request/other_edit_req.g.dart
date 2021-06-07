// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'other_edit_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtherEditRequest _$OtherEditRequestFromJson(Map<String, dynamic> json) {
  return OtherEditRequest(
    filterTimestamp: json['filter_timestamp'] as int,
    filterSubCategory: json['filter_sub_category'] as String,
    name: json['name'] as String,
    detail: json['detail'] as String,
    inventoryNumber: json['inventory_number'] as String,
    ip: json['ip'] as String,
    location: json['location'] as String,
    division: json['division'] as String,
    brand: json['brand'] as String,
    date: json['date'] as int,
    tag:
        (json['tag'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    note: json['note'] as String,
    type: json['type'] as String,
  );
}

Map<String, dynamic> _$OtherEditRequestToJson(OtherEditRequest instance) =>
    <String, dynamic>{
      'filter_timestamp': instance.filterTimestamp,
      'filter_sub_category': instance.filterSubCategory,
      'name': instance.name,
      'detail': instance.detail,
      'inventory_number': instance.inventoryNumber,
      'ip': instance.ip,
      'location': instance.location,
      'division': instance.division,
      'brand': instance.brand,
      'date': instance.date,
      'tag': instance.tag,
      'note': instance.note,
      'type': instance.type,
    };
