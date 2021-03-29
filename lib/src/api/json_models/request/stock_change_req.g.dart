// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_change_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockChangeRequest _$StockChangeRequestFromJson(Map<String, dynamic> json) {
  return StockChangeRequest(
    baNumber: json['ba_number'] as String,
    note: json['note'] as String,
    qty: json['qty'] as int,
    time: json['time'] as int,
  );
}

Map<String, dynamic> _$StockChangeRequestToJson(StockChangeRequest instance) =>
    <String, dynamic>{
      'ba_number': instance.baNumber,
      'note': instance.note,
      'qty': instance.qty,
      'time': instance.time,
    };
