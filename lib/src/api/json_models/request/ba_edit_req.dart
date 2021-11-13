import 'package:json_annotation/json_annotation.dart';
import 'ba_req.dart';

part 'ba_edit_req.g.dart';

@JsonSerializable(explicitToJson: true)
class BaEditRequest {
  BaEditRequest({
    required this.filterTimestamp,
    required this.number,
    required this.title,
    required this.date,
    required this.location,
    required this.equipments,
    required this.descriptions,
  });

  factory BaEditRequest.fromJson(Map<String, dynamic> json) =>
      _$BaEditRequestFromJson(json);
  Map<String, dynamic> toJson() => _$BaEditRequestToJson(this);

  @JsonKey(name: "filter_timestamp")
  final int filterTimestamp;
  final String number;
  final String title;
  final int date;
  final String location;
  @JsonKey(defaultValue: <EquipmentReq>[])
  final List<EquipmentReq> equipments;
  @JsonKey(defaultValue: <DescriptionReq>[])
  final List<DescriptionReq> descriptions;
}

@JsonSerializable()
class DescriptionReq {
  DescriptionReq(this.position, this.description, this.descriptionType);

  factory DescriptionReq.fromJson(Map<String, dynamic> json) =>
      _$DescriptionReqFromJson(json);
  Map<String, dynamic> toJson() => _$DescriptionReqToJson(this);

  final int position;
  final String description;
  @JsonKey(name: "description_type")
  final String descriptionType;
}
