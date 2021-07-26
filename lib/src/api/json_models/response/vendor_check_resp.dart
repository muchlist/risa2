import 'package:json_annotation/json_annotation.dart';

import 'error_resp.dart';

part 'vendor_check_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class VendorCheckDetailResponse {
  VendorCheckDetailResponse(this.error, this.data);
  final ErrorResp? error;
  final VendorCheckDetailResponseData? data;

  factory VendorCheckDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$VendorCheckDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VendorCheckDetailResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class VendorCheckDetailResponseData {
  VendorCheckDetailResponseData(
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
      this.isVirtualCheck,
      this.isFinish,
      this.note,
      this.vendorCheckItems);

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
  @JsonKey(name: "is_virtual_check")
  final bool isVirtualCheck;
  @JsonKey(name: "is_finish")
  final bool isFinish;
  final String note;
  @JsonKey(name: "vendor_check_items", defaultValue: [])
  final List<VendorCheckItem> vendorCheckItems;

  factory VendorCheckDetailResponseData.fromJson(Map<String, dynamic> json) =>
      _$VendorCheckDetailResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$VendorCheckDetailResponseDataToJson(this);
}

@JsonSerializable()
class VendorCheckItem {
  VendorCheckItem(
      this.id,
      this.name,
      this.location,
      this.checkedAt,
      this.checkedBy,
      this.isChecked,
      this.isBlur,
      this.isOffline,
      this.imagePath);

  final String id;
  final String name;
  final String location;
  @JsonKey(name: "checked_at")
  final int checkedAt;
  @JsonKey(name: "checked_by")
  final String checkedBy;
  @JsonKey(name: "is_checked")
  final bool isChecked;
  @JsonKey(name: "is_blur")
  final bool isBlur;
  @JsonKey(name: "is_offline")
  final bool isOffline;
  @JsonKey(name: "image_path")
  final String imagePath;

  factory VendorCheckItem.fromJson(Map<String, dynamic> json) =>
      _$VendorCheckItemFromJson(json);

  Map<String, dynamic> toJson() => _$VendorCheckItemToJson(this);
}
