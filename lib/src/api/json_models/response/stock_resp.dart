import 'package:json_annotation/json_annotation.dart';

import 'error_resp.dart';

part 'stock_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class StockDetailResponse {
  StockDetailResponse(this.error, this.data);

  factory StockDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$StockDetailResponseFromJson(json);
  final ErrorResp? error;
  final StockDetailResponseData? data;

  Map<String, dynamic> toJson() => _$StockDetailResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class StockDetailResponseData {
  StockDetailResponseData(
      this.id,
      this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.createdById,
      this.updatedBy,
      this.updatedById,
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
      this.note,
      this.increment,
      this.decrement);

  factory StockDetailResponseData.fromJson(Map<String, dynamic> json) =>
      _$StockDetailResponseDataFromJson(json);

  final String id;
  @JsonKey(name: "created_at")
  final int createdAt;
  @JsonKey(name: "updated_at")
  final int updatedAt;
  @JsonKey(name: "created_by")
  final String createdBy;
  @JsonKey(name: "created_by_id")
  final String createdById;
  @JsonKey(name: "updated_by")
  final String updatedBy;
  @JsonKey(name: "updated_by_id")
  final String updatedById;
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
  @JsonKey(defaultValue: <StockChange>[])
  final List<StockChange> increment;
  @JsonKey(defaultValue: <StockChange>[])
  final List<StockChange> decrement;

  Map<String, dynamic> toJson() => _$StockDetailResponseDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class StockChange {
  StockChange(
      this.dummyID, this.author, this.qty, this.baNumber, this.note, this.time);

  factory StockChange.fromJson(Map<String, dynamic> json) =>
      _$StockChangeFromJson(json);

  @JsonKey(name: "dummy_id")
  final int dummyID;
  final String author;
  final int qty;
  @JsonKey(name: "ba_number")
  final String baNumber;
  final String note;
  final int time;

  Map<String, dynamic> toJson() => _$StockChangeToJson(this);
}
