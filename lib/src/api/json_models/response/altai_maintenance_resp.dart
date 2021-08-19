import 'package:json_annotation/json_annotation.dart';

import 'error_resp.dart';

part 'altai_maintenance_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class AltaiMaintDetailResponse {
  AltaiMaintDetailResponse(this.error, this.data);

  factory AltaiMaintDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$AltaiMaintDetailResponseFromJson(json);
  final ErrorResp? error;
  final AltaiMaintDetailResponseData? data;

  Map<String, dynamic> toJson() => _$AltaiMaintDetailResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AltaiMaintDetailResponseData {
  AltaiMaintDetailResponseData(
      this.id,
      this.quarterlyMode,
      this.name,
      this.createdAt,
      this.createdBy,
      this.createdById,
      this.updatedAt,
      this.updatedBy,
      this.updatedById,
      this.branch,
      this.timeStarted,
      this.timeEnded,
      this.isFinish,
      this.note,
      this.altaiMaintCheckItems);

  factory AltaiMaintDetailResponseData.fromJson(Map<String, dynamic> json) =>
      _$AltaiMaintDetailResponseDataFromJson(json);

  final String id;
  @JsonKey(name: "quarterly_mode")
  final bool quarterlyMode;
  final String name;
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
  @JsonKey(name: "time_started")
  final int timeStarted;
  @JsonKey(name: "time_ended")
  final int timeEnded;
  @JsonKey(name: "is_finish")
  final bool isFinish;
  final String note;
  @JsonKey(name: "altai_phy_check_items", defaultValue: <AltaiMaintCheckItem>[])
  final List<AltaiMaintCheckItem> altaiMaintCheckItems;

  Map<String, dynamic> toJson() => _$AltaiMaintDetailResponseDataToJson(this);
}

@JsonSerializable()
class AltaiMaintCheckItem {
  AltaiMaintCheckItem(
      this.id,
      this.name,
      this.location,
      this.checkedAt,
      this.checkedBy,
      this.isChecked,
      this.isMaintained,
      this.isOffline,
      this.imagePath);

  factory AltaiMaintCheckItem.fromJson(Map<String, dynamic> json) =>
      _$AltaiMaintCheckItemFromJson(json);

  final String id;
  final String name;
  final String location;
  @JsonKey(name: "checked_at")
  final int checkedAt;
  @JsonKey(name: "checked_by")
  final String checkedBy;
  @JsonKey(name: "is_checked")
  final bool isChecked;
  @JsonKey(name: "is_maintained")
  final bool isMaintained;
  @JsonKey(name: "is_offline")
  final bool isOffline;
  @JsonKey(name: "image_path")
  final String imagePath;

  Map<String, dynamic> toJson() => _$AltaiMaintCheckItemToJson(this);
}
