// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'computer_edit_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComputerEditRequest _$ComputerEditRequestFromJson(Map<String, dynamic> json) {
  return ComputerEditRequest(
    filterTimestamp: json['filter_timestamp'] as int,
    name: json['name'] as String,
    hostname: json['hostname'] as String,
    inventoryNumber: json['inventory_number'] as String,
    ip: json['ip'] as String,
    location: json['location'] as String,
    division: json['division'] as String,
    seatManagement: json['seat_management'] as bool,
    os: json['os'] as String,
    processor: json['processor'] as String,
    ram: json['ram'] as int,
    hardisk: json['hardisk'] as int,
    brand: json['brand'] as String,
    date: json['date'] as int,
    tag:
        (json['tag'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    note: json['note'] as String,
    type: json['type'] as String,
  );
}

Map<String, dynamic> _$ComputerEditRequestToJson(
        ComputerEditRequest instance) =>
    <String, dynamic>{
      'filter_timestamp': instance.filterTimestamp,
      'name': instance.name,
      'hostname': instance.hostname,
      'inventory_number': instance.inventoryNumber,
      'ip': instance.ip,
      'location': instance.location,
      'division': instance.division,
      'seat_management': instance.seatManagement,
      'os': instance.os,
      'processor': instance.processor,
      'ram': instance.ram,
      'hardisk': instance.hardisk,
      'brand': instance.brand,
      'date': instance.date,
      'tag': instance.tag,
      'note': instance.note,
      'type': instance.type,
    };
