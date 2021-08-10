import 'package:json_annotation/json_annotation.dart';

part 'other_edit_req.g.dart';

@JsonSerializable()
class OtherEditRequest {
  OtherEditRequest(
      {required this.filterTimestamp,
      required this.filterSubCategory,
      required this.name,
      required this.detail,
      required this.inventoryNumber,
      required this.ip,
      required this.location,
      required this.division,
      required this.brand,
      required this.date,
      required this.tag,
      required this.note,
      required this.type});

  factory OtherEditRequest.fromJson(Map<String, dynamic> json) =>
      _$OtherEditRequestFromJson(json);

  @JsonKey(name: "filter_timestamp")
  final int filterTimestamp;
  @JsonKey(name: "filter_sub_category")
  final String filterSubCategory;
  final String name;
  final String detail;
  @JsonKey(name: "inventory_number")
  final String inventoryNumber;
  final String ip;
  final String location;
  final String division;
  final String brand;
  final int date;
  @JsonKey(defaultValue: <String>[])
  final List<String> tag;
  final String note;
  final String type;

  Map<String, dynamic> toJson() => _$OtherEditRequestToJson(this);
}
