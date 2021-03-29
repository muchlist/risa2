import 'package:json_annotation/json_annotation.dart';

part 'stock_req.g.dart';

@JsonSerializable()
class StockRequest {
  final String name;
  @JsonKey(name: "stock_category")
  final String stockCategory;
  final String location;
  final String unit;
  final int qty;
  final int threshold;
  final String note;
  final bool deactive;

  StockRequest(
      {required this.name,
      required this.stockCategory,
      required this.location,
      required this.unit,
      required this.qty,
      required this.threshold,
      required this.note,
      required this.deactive});

  factory StockRequest.fromJson(Map<String, dynamic> json) =>
      _$StockRequestFromJson(json);

  Map<String, dynamic> toJson() => _$StockRequestToJson(this);
}
