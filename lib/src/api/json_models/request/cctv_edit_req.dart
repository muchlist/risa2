import 'package:json_annotation/json_annotation.dart';

part 'cctv_edit_req.g.dart';

@JsonSerializable()
class CctvEditRequest {
  @JsonKey(name: "filter_timestamp")
  final String filterTimestamp;
  final String name;
  @JsonKey(name: "inventory_number")
  final String inventoryNumber;
  final String ip;
  final String location;
  final String brand;
  final int date;
  @JsonKey(defaultValue: [])
  final List<String> tag;
  final String note;
  final String type;

  CctvEditRequest(
      {required this.filterTimestamp,
      required this.name,
      required this.inventoryNumber,
      required this.ip,
      required this.location,
      required this.brand,
      required this.date,
      required this.tag,
      required this.note,
      required this.type});

  factory CctvEditRequest.fromJson(Map<String, dynamic> json) =>
      _$CctvEditRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CctvEditRequestToJson(this);
}
