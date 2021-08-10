import 'package:json_annotation/json_annotation.dart';

import 'error_resp.dart';

part 'stock_list_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class StockListResponse {
  StockListResponse(this.error, this.data);

  factory StockListResponse.fromJson(Map<String, dynamic> json) =>
      _$StockListResponseFromJson(json);

  final ErrorResp? error;
  @JsonKey(defaultValue: <StockMinResponse>[])
  final List<StockMinResponse> data;

  Map<String, dynamic> toJson() => _$StockListResponseToJson(this);
}

@JsonSerializable()
class StockMinResponse {
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
  @JsonKey(defaultValue: <String>[])
  final List<String> tag;
  final String image;
  final String note;

  Map<String, dynamic> toJson() => _$StockMinResponseToJson(this);
}
