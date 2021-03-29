import 'package:json_annotation/json_annotation.dart';

import 'error_resp.dart';

part 'stock_list_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class StockListResponse {
  final ErrorResp? error;
  @JsonKey(defaultValue: [])
  final List<StockMinResponse> data;

  StockListResponse(this.error, this.data);

  factory StockListResponse.fromJson(Map<String, dynamic> json) =>
      _$StockListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StockListResponseToJson(this);
}

@JsonSerializable()
class StockMinResponse {
  final String id;
  final String branch;
  final bool disable;
  final String name;
  @JsonKey(name: "stock_category")
  final String stockCategory;
  final String unit;
  final int qty;
  final int threshold;
  final String location;
  @JsonKey(defaultValue: [])
  final List<String> tag;
  final String image;
  final String note;

  StockMinResponse(
      this.id,
      this.branch,
      this.disable,
      this.name,
      this.stockCategory,
      this.unit,
      this.qty,
      this.threshold,
      this.location,
      this.tag,
      this.image,
      this.note);

  factory StockMinResponse.fromJson(Map<String, dynamic> json) =>
      _$StockMinResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StockMinResponseToJson(this);
}
