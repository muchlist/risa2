// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'computer_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComputerRequest _$ComputerRequestFromJson(Map<String, dynamic> json) {
  return ComputerRequest(
    name: json['name'] as String,
    hostname: json['inventory_number'] as String,
    inventoryNumber: json['inventoryNumber'] as String,
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

Map<String, dynamic> _$ComputerRequestToJson(ComputerRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'inventory_number': instance.hostname,
      'inventoryNumber': instance.inventoryNumber,
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
