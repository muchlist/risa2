// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ba_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaRequest _$BaRequestFromJson(Map<String, dynamic> json) {
  return BaRequest(
    number: json['number'] as String,
    title: json['title'] as String,
    date: json['date'] as int,
    location: json['location'] as String,
    actions:
        (json['actions'] as List<dynamic>?)?.map((e) => e as String).toList() ??
            [],
    equipments: (json['equipments'] as List<dynamic>?)
            ?.map((e) => EquipmentReq.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$BaRequestToJson(BaRequest instance) => <String, dynamic>{
      'number': instance.number,
      'title': instance.title,
      'date': instance.date,
      'location': instance.location,
      'actions': instance.actions,
      'equipments': instance.equipments.map((e) => e.toJson()).toList(),
    };

EquipmentReq _$EquipmentReqFromJson(Map<String, dynamic> json) {
  return EquipmentReq(
    json['id'] as String,
    json['equipment_name'] as String,
    json['attach_to'] as String,
    json['description'] as String,
    json['qty'] as int,
  );
}

Map<String, dynamic> _$EquipmentReqToJson(EquipmentReq instance) =>
    <String, dynamic>{
      'id': instance.id,
      'equipment_name': instance.equipmentName,
      'attach_to': instance.attachTo,
      'description': instance.description,
      'qty': instance.qty,
    };
