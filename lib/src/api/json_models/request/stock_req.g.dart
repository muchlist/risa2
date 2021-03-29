// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockRequest _$StockRequestFromJson(Map<String, dynamic> json) {
  return StockRequest(
    name: json['name'] as String,
    stockCategory: json['stock_category'] as String,
    location: json['location'] as String,
    unit: json['unit'] as String,
    qty: json['qty'] as int,
    threshold: json['threshold'] as int,
    note: json['note'] as String,
    deactive: json['deactive'] as bool,
  );
}

Map<String, dynamic> _$StockRequestToJson(StockRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'stock_category': instance.stockCategory,
      'location': instance.location,
      'unit': instance.unit,
      'qty': instance.qty,
      'threshold': instance.threshold,
      'note': instance.note,
      'deactive': instance.deactive,
    };
