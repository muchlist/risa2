import 'package:json_annotation/json_annotation.dart';

import 'error_resp.dart';

part 'ba_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class BaDetailResponse {
  BaDetailResponse(this.error, this.data);

  factory BaDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$BaDetailResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BaDetailResponseToJson(this);

  final ErrorResp? error;
  final BaDetailResponseData? data;
}

@JsonSerializable(explicitToJson: true)
class BaDetailResponseData {
  BaDetailResponseData(
      this.id,
      this.createdAt,
      this.createdBy,
      this.createdById,
      this.updatedAt,
      this.updatedBy,
      this.updatedById,
      this.branch,
      this.number,
      this.title,
      this.date,
      this.participants,
      this.approvers,
      this.completeStatus,
      this.location,
      this.images,
      this.docType,
      this.descriptions,
      this.equipments);

  factory BaDetailResponseData.fromJson(Map<String, dynamic> json) =>
      _$BaDetailResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$BaDetailResponseDataToJson(this);

  final String id;
  @JsonKey(name: "created_at")
  final int createdAt;
  @JsonKey(name: "created_by")
  final String createdBy;
  @JsonKey(name: "created_by_id")
  final String createdById;
  @JsonKey(name: "updated_at")
  final int updatedAt;
  @JsonKey(name: "updated_by")
  final String updatedBy;
  @JsonKey(name: "updated_by_id")
  final String updatedById;
  final String branch;
  final String number;
  final String title;
  final int date;
  @JsonKey(name: "complete_status")
  final int completeStatus;
  final String location;
  @JsonKey(name: "doc_type")
  final String docType;
  @JsonKey(defaultValue: <String>[])
  final List<String> images;
  @JsonKey(defaultValue: <Participant>[])
  final List<Participant> participants;
  @JsonKey(defaultValue: <Participant>[])
  final List<Participant> approvers;
  @JsonKey(defaultValue: <Description>[])
  final List<Description> descriptions;
  @JsonKey(defaultValue: <Equipment>[])
  final List<Equipment> equipments;
}

@JsonSerializable()
class Participant {
  Participant(
    this.id,
    this.name,
    this.alias,
    this.division,
    this.userID,
    this.sign,
    this.signAt,
  );

  factory Participant.fromJson(Map<String, dynamic> json) =>
      _$ParticipantFromJson(json);
  Map<String, dynamic> toJson() => _$ParticipantToJson(this);

  final String id;
  final String name;
  final String alias;
  final String division;
  @JsonKey(name: "user_id")
  final String userID;
  final String sign;
  @JsonKey(name: "sign_at")
  final int signAt;
}

@JsonSerializable()
class Description {
  Description(this.position, this.description, this.descriptionType);

  factory Description.fromJson(Map<String, dynamic> json) =>
      _$DescriptionFromJson(json);
  Map<String, dynamic> toJson() => _$DescriptionToJson(this);

  final int position;
  final String description;
  @JsonKey(name: "description_type")
  final String descriptionType;
}

@JsonSerializable()
class Equipment {
  Equipment(
      this.id, this.equipmentName, this.attachTo, this.description, this.qty);

  factory Equipment.fromJson(Map<String, dynamic> json) =>
      _$EquipmentFromJson(json);
  Map<String, dynamic> toJson() => _$EquipmentToJson(this);

  final String id;
  @JsonKey(name: "equipment_name")
  final String equipmentName;
  @JsonKey(name: "attach_to")
  final String attachTo;
  final String description;
  final int qty;
}
