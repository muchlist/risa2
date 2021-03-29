import 'package:json_annotation/json_annotation.dart';

part 'stock_change_req.g.dart';

@JsonSerializable()
class StockChangeRequest {
  @JsonKey(name: "ba_number")
  final String baNumber;
  final String note;
  final int qty;
  final int time;

  StockChangeRequest(
      {required this.baNumber,
      required this.note,
      required this.qty,
      required this.time});

  factory StockChangeRequest.fromJson(Map<String, dynamic> json) =>
      _$StockChangeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$StockChangeRequestToJson(this);
}
