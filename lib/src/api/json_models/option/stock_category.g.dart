// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OptStockCategory _$OptStockCategoryFromJson(Map<String, dynamic> json) {
  return OptStockCategory(
    (json['category'] as List<dynamic>?)?.map((e) => e as String).toList() ??
        [],
  );
}

Map<String, dynamic> _$OptStockCategoryToJson(OptStockCategory instance) =>
    <String, dynamic>{
      'category': instance.category,
    };
