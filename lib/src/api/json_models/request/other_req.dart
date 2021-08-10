import 'package:json_annotation/json_annotation.dart';

part 'other_req.g.dart';

@JsonSerializable()
class OtherRequest {
  OtherRequest(
      {required this.subCategory,
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

  factory OtherRequest.fromJson(Map<String, dynamic> json) =>
      _$OtherRequestFromJson(json);

  @JsonKey(name: "sub_category")
  final String subCategory;
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

  Map<String, dynamic> toJson() => _$OtherRequestToJson(this);
}
