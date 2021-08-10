import 'package:json_annotation/json_annotation.dart';

part 'computer_edit_req.g.dart';

@JsonSerializable()
class ComputerEditRequest {
  ComputerEditRequest(
      {required this.filterTimestamp,
      required this.name,
      required this.hostname,
      required this.inventoryNumber,
      required this.ip,
      required this.location,
      required this.division,
      required this.seatManagement,
      required this.os,
      required this.processor,
      required this.ram,
      required this.hardisk,
      required this.brand,
      required this.date,
      required this.tag,
      required this.note,
      required this.type});

  factory ComputerEditRequest.fromJson(Map<String, dynamic> json) =>
      _$ComputerEditRequestFromJson(json);

  @JsonKey(name: "filter_timestamp")
  final int filterTimestamp;
  final String name;
  final String hostname;
  @JsonKey(name: "inventory_number")
  final String inventoryNumber;
  final String ip;
  final String location;
  final String division;
  @JsonKey(name: "seat_management")
  final bool seatManagement;
  final String os;
  final String processor;
  final int ram;
  final int hardisk;
  final String brand;
  final int date;
  @JsonKey(defaultValue: <String>[])
  final List<String> tag;
  final String note;
  final String type;

  Map<String, dynamic> toJson() => _$ComputerEditRequestToJson(this);
}
