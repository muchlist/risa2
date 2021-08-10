import 'package:json_annotation/json_annotation.dart';

part 'stock_change_req.g.dart';

@JsonSerializable()
class StockChangeRequest {
  StockChangeRequest(
      {required this.baNumber,
      required this.note,
      required this.qty,
      required this.time});

  factory StockChangeRequest.fromJson(Map<String, dynamic> json) =>
      _$StockChangeRequestFromJson(json);

  @JsonKey(name: "ba_number")
  final String baNumber;
  final String note;
  final int qty;
  final int time;

  Map<String, dynamic> toJson() => _$StockChangeRequestToJson(this);
}
