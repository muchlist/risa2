import 'package:json_annotation/json_annotation.dart';

import 'error_resp.dart';

part 'config_check_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class ConfigCheckDetailResponse {
  ConfigCheckDetailResponse(this.error, this.data);

  factory ConfigCheckDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$ConfigCheckDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigCheckDetailResponseToJson(this);

  final ErrorResp? error;
  final ConfigCheckDetailResponseData? data;
}

@JsonSerializable(explicitToJson: true)
class ConfigCheckDetailResponseData {
  ConfigCheckDetailResponseData(
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
      this.configCheckItems);

  factory ConfigCheckDetailResponseData.fromJson(Map<String, dynamic> json) =>
      _$ConfigCheckDetailResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigCheckDetailResponseDataToJson(this);

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
  @JsonKey(name: "config_check_items", defaultValue: <ConfigCheckItem>[])
  final List<ConfigCheckItem> configCheckItems;
}

@JsonSerializable()
class ConfigCheckItem {
  ConfigCheckItem(this.id, this.name, this.location, this.checkedAt,
      this.checkedBy, this.isUpdated);

  factory ConfigCheckItem.fromJson(Map<String, dynamic> json) =>
      _$ConfigCheckItemFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigCheckItemToJson(this);

  final String id;
  final String name;
  final String location;
  @JsonKey(name: "checked_at")
  final int checkedAt;
  @JsonKey(name: "checked_by")
  final String checkedBy;
  @JsonKey(name: "is_updated")
  final bool isUpdated;
}
