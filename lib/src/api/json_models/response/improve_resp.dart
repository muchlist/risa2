import 'package:json_annotation/json_annotation.dart';

import 'error_resp.dart';

part 'improve_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class ImproveDetailResponse {
  ImproveDetailResponse(this.error, this.data);

  factory ImproveDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$ImproveDetailResponseFromJson(json);
  final ErrorResp? error;
  final ImproveDetailResponseData? data;

  Map<String, dynamic> toJson() => _$ImproveDetailResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ImproveDetailResponseData {
  ImproveDetailResponseData(
      this.id,
      this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.createdById,
      this.updatedBy,
      this.updatedById,
      this.branch,
      this.title,
      this.description,
      this.goal,
      this.goalsAchieved,
      this.isActive,
      this.completeStatus,
      this.improveChanges);

  factory ImproveDetailResponseData.fromJson(Map<String, dynamic> json) =>
      _$ImproveDetailResponseDataFromJson(json);

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
  final String title;
  final String description;
  final int goal;
  @JsonKey(name: "goals_achieved")
  final int goalsAchieved;
  @JsonKey(name: "is_active")
  final bool isActive;
  @JsonKey(name: "complete_status")
  final int completeStatus;
  @JsonKey(defaultValue: <ImproveChange>[], name: "improve_changes")
  final List<ImproveChange> improveChanges;

  Map<String, dynamic> toJson() => _$ImproveDetailResponseDataToJson(this);
}

@JsonSerializable()
class ImproveChange {
  ImproveChange(
      {required this.dummyId,
      required this.author,
      required this.increment,
      required this.note,
      required this.time});

  factory ImproveChange.fromJson(Map<String, dynamic> json) =>
      _$ImproveChangeFromJson(json);

  @JsonKey(name: "dummy_id")
  final int dummyId;
  final String author;
  final int increment;
  final String note;
  final int time;

  Map<String, dynamic> toJson() => _$ImproveChangeToJson(this);
}
