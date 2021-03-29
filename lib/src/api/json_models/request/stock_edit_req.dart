import 'package:json_annotation/json_annotation.dart';

part 'stock_edit_req.g.dart';

@JsonSerializable()
class StockEditRequest {
  @JsonKey(name: "filter_timestamp")
  final int filterTimestamp;
  final String name;
  @JsonKey(name: "stock_category")
  final String stockCategory;
  final String location;
  final String unit;
  final int threshold;
  final String note;

  StockEditRequest(
      {required this.filterTimestamp,
      required this.name,
      required this.stockCategory,
      required this.location,
      required this.unit,
      required this.threshold,
      required this.note});

  factory StockEditRequest.fromJson(Map<String, dynamic> json) =>
      _$StockEditRequestFromJson(json);

  Map<String, dynamic> toJson() => _$StockEditRequestToJson(this);
}
