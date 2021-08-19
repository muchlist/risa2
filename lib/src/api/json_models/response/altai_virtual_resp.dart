import 'package:json_annotation/json_annotation.dart';

import 'error_resp.dart';

part 'altai_virtual_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class AltaiVirtualDetailResponse {
  AltaiVirtualDetailResponse(this.error, this.data);

  factory AltaiVirtualDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$AltaiVirtualDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AltaiVirtualDetailResponseToJson(this);

  final ErrorResp? error;
  final AltaiVirtualDetailResponseData? data;
}

@JsonSerializable(explicitToJson: true)
class AltaiVirtualDetailResponseData {
  AltaiVirtualDetailResponseData(
      this.id,
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
      this.altaiCheckItems);

  factory AltaiVirtualDetailResponseData.fromJson(Map<String, dynamic> json) =>
      _$AltaiVirtualDetailResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$AltaiVirtualDetailResponseDataToJson(this);

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
  @JsonKey(name: "time_started")
  final int timeStarted;
  @JsonKey(name: "time_ended")
  final int timeEnded;
  @JsonKey(name: "is_finish")
  final bool isFinish;
  final String note;
  @JsonKey(name: "altai_check_items", defaultValue: <AltaiCheckItem>[])
  final List<AltaiCheckItem> altaiCheckItems;
}

@JsonSerializable()
class AltaiCheckItem {
  AltaiCheckItem(this.id, this.name, this.location, this.checkedAt,
      this.checkedBy, this.isChecked, this.isOffline, this.imagePath);

  factory AltaiCheckItem.fromJson(Map<String, dynamic> json) =>
      _$AltaiCheckItemFromJson(json);

  final String id;
  final String name;
  final String location;
  @JsonKey(name: "checked_at")
  final int checkedAt;
  @JsonKey(name: "checked_by")
  final String checkedBy;
  @JsonKey(name: "is_checked")
  final bool isChecked;
  @JsonKey(name: "is_offline")
  final bool isOffline;
  @JsonKey(name: "image_path")
  final String imagePath;

  Map<String, dynamic> toJson() => _$AltaiCheckItemToJson(this);
}
