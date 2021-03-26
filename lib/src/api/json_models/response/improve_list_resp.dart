import 'package:json_annotation/json_annotation.dart';

import 'error_resp.dart';

part 'improve_list_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class ImproveListResponse {
  final ErrorResp? error;
  @JsonKey(defaultValue: [])
  final List<ImproveMinResponseData> data;

  ImproveListResponse(this.error, this.data);

  factory ImproveListResponse.fromJson(Map<String, dynamic> json) =>
      _$ImproveListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ImproveListResponseToJson(this);
}

@JsonSerializable()
class ImproveMinResponseData {
  final String id;
  @JsonKey(name: "created_at")
  final int createdAt;
  @JsonKey(name: "updated_at")
  final int updatedAt;
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

  ImproveMinResponseData(
      this.id,
      this.createdAt,
      this.updatedAt,
      this.branch,
      this.title,
      this.description,
      this.goal,
      this.goalsAchieved,
      this.isActive,
      this.completeStatus);

  factory ImproveMinResponseData.fromJson(Map<String, dynamic> json) =>
      _$ImproveMinResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$ImproveMinResponseDataToJson(this);
}
