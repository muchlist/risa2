// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_edit_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockEditRequest _$StockEditRequestFromJson(Map<String, dynamic> json) {
  return StockEditRequest(
    filterTimestamp: json['filter_timestamp'] as int,
    name: json['name'] as String,
    stockCategory: json['stock_category'] as String,
    location: json['location'] as String,
    unit: json['unit'] as String,
    threshold: json['threshold'] as int,
    note: json['note'] as String,
  );
}

Map<String, dynamic> _$StockEditRequestToJson(StockEditRequest instance) =>
    <String, dynamic>{
      'filter_timestamp': instance.filterTimestamp,
      'name': instance.name,
      'stock_category': instance.stockCategory,
      'location': instance.location,
      'unit': instance.unit,
      'threshold': instance.threshold,
      'note': instance.note,
    };
