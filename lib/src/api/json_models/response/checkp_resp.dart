import 'package:json_annotation/json_annotation.dart';

import 'error_resp.dart';

part 'checkp_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class CheckpDetailResponse {
  final ErrorResp? error;
  final CheckpDetailResponseData? data;

  CheckpDetailResponse(this.error, this.data);

  factory CheckpDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckpDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CheckpDetailResponseToJson(this);
}

@JsonSerializable()
class CheckpDetailResponseData {
  final String id;
  @JsonKey(name: "created_at")
  final int createdAt;
  @JsonKey(name: "updated_at")
  final int updatedAt;
  @JsonKey(name: "created_by")
  final String createdBy;
  @JsonKey(name: "created_by_id")
  final String createdById;
  @JsonKey(name: "updated_by")
  final String updatedBy;
  @JsonKey(name: "updated_by_id")
  final String updatedById;
  final String branch;
  final bool disable;
  final String name;
  final String location;
  @JsonKey(name: "location_lat")
  final String locationLat;
  @JsonKey(name: "location_lon")
  final String locationLon;
  final String type;
  @JsonKey(defaultValue: [])
  final List<String> tag;
  @JsonKey(defaultValue: [])
  final List<String> tagExtra;
  final String note;
  @JsonKey(defaultValue: [])
  final List<int> shifts;
  @JsonKey(name: "checked_note")
  final String checkedNote;
  @JsonKey(name: "have_problem")
  final bool haveProblem;
  @JsonKey(name: "complete_status")
  final int completeStatus;

  CheckpDetailResponseData(
      this.id,
      this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.createdById,
      this.updatedBy,
      this.updatedById,
      this.branch,
      this.disable,
      this.name,
      this.location,
      this.locationLat,
      this.locationLon,
      this.type,
      this.tag,
      this.tagExtra,
      this.note,
      this.shifts,
      this.checkedNote,
      this.haveProblem,
      this.completeStatus);

  factory CheckpDetailResponseData.fromJson(Map<String, dynamic> json) =>
      _$CheckpDetailResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$CheckpDetailResponseDataToJson(this);
}
