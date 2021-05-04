import 'package:json_annotation/json_annotation.dart';

part 'stock_category.g.dart';

@JsonSerializable()
class OptStockCategory {
  @JsonKey(defaultValue: [])
  final List<String> category;

  OptStockCategory(this.category);

  factory OptStockCategory.fromJson(Map<String, dynamic> json) =>
      _$OptStockCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$OptStockCategoryToJson(this);
}
