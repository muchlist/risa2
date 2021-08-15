import 'package:json_annotation/json_annotation.dart';

import 'error_resp.dart';

part 'cctv_maintenance_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class CCTVMaintDetailResponse {
  CCTVMaintDetailResponse(this.error, this.data);

  factory CCTVMaintDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$CCTVMaintDetailResponseFromJson(json);
  final ErrorResp? error;
  final CCTVMaintDetailResponseData? data;

  Map<String, dynamic> toJson() => _$CCTVMaintDetailResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CCTVMaintDetailResponseData {
  CCTVMaintDetailResponseData(
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
      this.cctvMaintCheckItems);

  factory CCTVMaintDetailResponseData.fromJson(Map<String, dynamic> json) =>
      _$CCTVMaintDetailResponseDataFromJson(json);

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
  @JsonKey(name: "ven_phy_check_items", defaultValue: <CCTVMaintCheckItem>[])
  final List<CCTVMaintCheckItem> cctvMaintCheckItems;

  Map<String, dynamic> toJson() => _$CCTVMaintDetailResponseDataToJson(this);
}

@JsonSerializable()
class CCTVMaintCheckItem {
  CCTVMaintCheckItem(
      this.id,
      this.name,
      this.location,
      this.checkedAt,
      this.checkedBy,
      this.isChecked,
      this.isMaintained,
      this.isBlur,
      this.isOffline,
      this.imagePath);

  factory CCTVMaintCheckItem.fromJson(Map<String, dynamic> json) =>
      _$CCTVMaintCheckItemFromJson(json);

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
  @JsonKey(name: "is_blur")
  final bool isBlur;
  @JsonKey(name: "is_offline")
  final bool isOffline;
  @JsonKey(name: "image_path")
  final String imagePath;

  Map<String, dynamic> toJson() => _$CCTVMaintCheckItemToJson(this);
}
