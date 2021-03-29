// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_list_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockListResponse _$StockListResponseFromJson(Map<String, dynamic> json) {
  return StockListResponse(
    json['error'] == null
        ? null
        : ErrorResp.fromJson(json['error'] as Map<String, dynamic>),
    (json['data'] as List<dynamic>?)
            ?.map((e) => StockMinResponse.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$StockListResponseToJson(StockListResponse instance) =>
    <String, dynamic>{
      'error': instance.error?.toJson(),
      'data': instance.data.map((e) => e.toJson()).toList(),
    };

StockMinResponse _$StockMinResponseFromJson(Map<String, dynamic> json) {
  return StockMinResponse(
    json['id'] as String,
    json['branch'] as String,
    json['disable'] as bool,
    json['name'] as String,
    json['stock_category'] as String,
    json['unit'] as String,
    json['qty'] as int,
    json['threshold'] as int,
    json['location'] as String,
    (json['tag'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    json['image'] as String,
    json['note'] as String,
  );
}

Map<String, dynamic> _$StockMinResponseToJson(StockMinResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'branch': instance.branch,
      'disable': instance.disable,
      'name': instance.name,
      'stock_category': instance.stockCategory,
      'unit': instance.unit,
      'qty': instance.qty,
      'threshold': instance.threshold,
      'location': instance.location,
      'tag': instance.tag,
      'image': instance.image,
      'note': instance.note,
    };
