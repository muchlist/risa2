import 'package:json_annotation/json_annotation.dart';

part 'stock_category.g.dart';

@JsonSerializable()
class OptStockCategory {
  OptStockCategory(this.category);

  factory OptStockCategory.fromJson(Map<String, dynamic> json) =>
      _$OptStockCategoryFromJson(json);
  @JsonKey(defaultValue: <String>[])
  final List<String> category;

  Map<String, dynamic> toJson() => _$OptStockCategoryToJson(this);
}
