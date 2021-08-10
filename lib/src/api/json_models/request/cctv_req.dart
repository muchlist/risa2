import 'package:json_annotation/json_annotation.dart';

part 'cctv_req.g.dart';

@JsonSerializable()
class CctvRequest {
  CctvRequest(
      {required this.name,
      required this.inventoryNumber,
      required this.ip,
      required this.location,
      required this.brand,
      required this.date,
      required this.tag,
      required this.note,
      required this.type});

  factory CctvRequest.fromJson(Map<String, dynamic> json) =>
      _$CctvRequestFromJson(json);

  final String name;
  @JsonKey(name: "inventory_number")
  final String inventoryNumber;
  final String ip;
  final String location;
  final String brand;
  final int date;
  @JsonKey(defaultValue: <String>[])
  final List<String> tag;
  final String note;
  final String type;

  Map<String, dynamic> toJson() => _$CctvRequestToJson(this);
}
