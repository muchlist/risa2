// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ba_edit_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaEditRequest _$BaEditRequestFromJson(Map<String, dynamic> json) {
  return BaEditRequest(
    filterTimestamp: json['filter_timestamp'] as int,
    number: json['number'] as String,
    title: json['title'] as String,
    date: json['date'] as int,
    location: json['location'] as String,
    equipments: (json['equipments'] as List<dynamic>?)
            ?.map((e) => EquipmentReq.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    descriptions: (json['descriptions'] as List<dynamic>?)
            ?.map((e) => DescriptionReq.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$BaEditRequestToJson(BaEditRequest instance) =>
    <String, dynamic>{
      'filter_timestamp': instance.filterTimestamp,
      'number': instance.number,
      'title': instance.title,
      'date': instance.date,
      'location': instance.location,
      'equipments': instance.equipments.map((e) => e.toJson()).toList(),
      'descriptions': instance.descriptions.map((e) => e.toJson()).toList(),
    };

DescriptionReq _$DescriptionReqFromJson(Map<String, dynamic> json) {
  return DescriptionReq(
    json['position'] as int,
    json['description'] as String,
    json['description_type'] as String,
  );
}

Map<String, dynamic> _$DescriptionReqToJson(DescriptionReq instance) =>
    <String, dynamic>{
      'position': instance.position,
      'description': instance.description,
      'description_type': instance.descriptionType,
    };
