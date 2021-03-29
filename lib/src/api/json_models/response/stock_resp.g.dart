// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockDetailResponse _$StockDetailResponseFromJson(Map<String, dynamic> json) {
  return StockDetailResponse(
    json['error'] == null
        ? null
        : ErrorResp.fromJson(json['error'] as Map<String, dynamic>),
    json['data'] == null
        ? null
        : StockDetailResponseData.fromJson(
            json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$StockDetailResponseToJson(
        StockDetailResponse instance) =>
    <String, dynamic>{
      'error': instance.error?.toJson(),
      'data': instance.data?.toJson(),
    };

StockDetailResponseData _$StockDetailResponseDataFromJson(
    Map<String, dynamic> json) {
  return StockDetailResponseData(
    json['id'] as String,
    json['created_at'] as int,
    json['updated_at'] as int,
    json['created_by'] as String,
    json['created_by_id'] as String,
    json['updated_by'] as String,
    json['updated_by_id'] as String,
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
    (json['increment'] as List<dynamic>?)
            ?.map((e) => StockChange.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    (json['decrement'] as List<dynamic>?)
            ?.map((e) => StockChange.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$StockDetailResponseDataToJson(
        StockDetailResponseData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'created_by': instance.createdBy,
      'created_by_id': instance.createdById,
      'updated_by': instance.updatedBy,
      'updated_by_id': instance.updatedById,
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
      'increment': instance.increment.map((e) => e.toJson()).toList(),
      'decrement': instance.decrement.map((e) => e.toJson()).toList(),
    };

StockChange _$StockChangeFromJson(Map<String, dynamic> json) {
  return StockChange(
    json['dummy_id'] as String,
    json['author'] as int,
    json['qty'] as int,
    json['ba_number'] as int,
    json['note'] as String,
    json['time'] as int,
  );
}

Map<String, dynamic> _$StockChangeToJson(StockChange instance) =>
    <String, dynamic>{
      'dummy_id': instance.dummyID,
      'author': instance.author,
      'qty': instance.qty,
      'ba_number': instance.baNumber,
      'note': instance.note,
      'time': instance.time,
    };
