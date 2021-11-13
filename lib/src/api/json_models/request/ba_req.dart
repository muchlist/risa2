import 'package:json_annotation/json_annotation.dart';

part 'ba_req.g.dart';

@JsonSerializable(explicitToJson: true)
class BaRequest {
  BaRequest({
    required this.number,
    required this.title,
    required this.date,
    required this.location,
    required this.actions,
    required this.equipments,
  });

  factory BaRequest.fromJson(Map<String, dynamic> json) =>
      _$BaRequestFromJson(json);

  final String number;
  final String title;
  final int date;
  final String location;
  @JsonKey(defaultValue: <String>[])
  final List<String> actions;
  @JsonKey(defaultValue: <EquipmentReq>[])
  final List<EquipmentReq> equipments;

  Map<String, dynamic> toJson() => _$BaRequestToJson(this);
}

@JsonSerializable()
class EquipmentReq {
  EquipmentReq(
    this.id,
    this.equipmentName,
    this.attachTo,
    this.description,
    this.qty,
  );
  factory EquipmentReq.fromJson(Map<String, dynamic> json) =>
      _$EquipmentReqFromJson(json);
  Map<String, dynamic> toJson() => _$EquipmentReqToJson(this);

  final String id;
  @JsonKey(name: "equipment_name")
  final String equipmentName;
  @JsonKey(name: "attach_to")
  final String attachTo;
  final String description;
  final int qty;
}
