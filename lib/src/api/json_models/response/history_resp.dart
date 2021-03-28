import 'package:json_annotation/json_annotation.dart';

import 'error_resp.dart';

part 'history_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class HistoryDetailResponse {
  final ErrorResp? error;
  final HistoryDetailResponseData? data;

  HistoryDetailResponse(this.error, this.data);

  factory HistoryDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$HistoryDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryDetailResponseToJson(this);
}

@JsonSerializable()
class HistoryDetailResponseData {
  final String id;
  @JsonKey(name: "created_at")
  final int createdAt;
  @JsonKey(name: "updated_at")
  final int updatedAt;
  @JsonKey(name: "created_by")
  final String createdBy;
  @JsonKey(name: "updated_by")
  final String updatedBy;
  final String category;
  final String branch;
  @JsonKey(name: "parent_id")
  final String parentID;
  @JsonKey(name: "parent_name")
  final String parentName;
  final String status;
  final String problem;
  @JsonKey(name: "problem_resolve")
  final String problemResolve;
  @JsonKey(name: "complete_status")
  final String completeStatus;
  @JsonKey(name: "date_start")
  final int dateStart;
  @JsonKey(name: "date_end")
  final int dateEnd;
  @JsonKey(defaultValue: [])
  final List<String> tag;
  final String image;

  HistoryDetailResponseData(
      this.id,
      this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.updatedBy,
      this.category,
      this.branch,
      this.parentID,
      this.parentName,
      this.status,
      this.problem,
      this.problemResolve,
      this.completeStatus,
      this.dateStart,
      this.dateEnd,
      this.tag,
      this.image);

  factory HistoryDetailResponseData.fromJson(Map<String, dynamic> json) =>
      _$HistoryDetailResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryDetailResponseDataToJson(this);
}
