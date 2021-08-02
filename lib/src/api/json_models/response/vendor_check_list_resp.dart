import 'package:json_annotation/json_annotation.dart';

import 'error_resp.dart';

part 'vendor_check_list_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class VendorCheckListResponse {
  final ErrorResp? error;
  @JsonKey(defaultValue: [])
  final List<VendorCheckMinResponse> data;

  VendorCheckListResponse(this.error, this.data);

  factory VendorCheckListResponse.fromJson(Map<String, dynamic> json) =>
      _$VendorCheckListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VendorCheckListResponseToJson(this);
}

@JsonSerializable()
class VendorCheckMinResponse {
  VendorCheckMinResponse(
      this.id,
      this.createdAt,
      this.createdBy,
      this.updatedAt,
      this.updatedBy,
      this.branch,
      this.timeStarted,
      this.timeEnded,
      this.isVirtualCheck,
      this.isFinish,
      this.note);

  final String id;
  @JsonKey(name: "created_at")
  final int createdAt;
  @JsonKey(name: "created_by")
  final String createdBy;
  @JsonKey(name: "updated_at")
  final int updatedAt;
  @JsonKey(name: "updated_by")
  final String updatedBy;
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

  factory VendorCheckMinResponse.fromJson(Map<String, dynamic> json) =>
      _$VendorCheckMinResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VendorCheckMinResponseToJson(this);
}
