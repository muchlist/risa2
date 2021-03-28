// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cctv_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CctvRequest _$CctvRequestFromJson(Map<String, dynamic> json) {
  return CctvRequest(
    name: json['name'] as String,
    inventoryNumber: json['inventory_number'] as String,
    ip: json['ip'] as String,
    location: json['location'] as String,
    brand: json['brand'] as String,
    date: json['date'] as int,
    tag:
        (json['tag'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    note: json['note'] as String,
    type: json['type'] as String,
  );
}

Map<String, dynamic> _$CctvRequestToJson(CctvRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'inventory_number': instance.inventoryNumber,
      'ip': instance.ip,
      'location': instance.location,
      'brand': instance.brand,
      'date': instance.date,
      'tag': instance.tag,
      'note': instance.note,
      'type': instance.type,
    };
