import 'package:json_annotation/json_annotation.dart';

import 'error_resp.dart';

part 'history_list_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class HistoryListResponse {
  HistoryListResponse(this.error, this.data);

  factory HistoryListResponse.fromJson(Map<String, dynamic> json) =>
      _$HistoryListResponseFromJson(json);
  final ErrorResp? error;
  @JsonKey(defaultValue: <HistoryMinResponse>[])
  final List<HistoryMinResponse> data;

  Map<String, dynamic> toJson() => _$HistoryListResponseToJson(this);
}

@JsonSerializable()
class HistoryMinResponse {
  HistoryMinResponse(
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

  factory HistoryMinResponse.fromJson(Map<String, dynamic> json) =>
      _$HistoryMinResponseFromJson(json);

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
  final int completeStatus;
  @JsonKey(name: "date_start")
  final int dateStart;
  @JsonKey(name: "date_end")
  final int dateEnd;
  @JsonKey(defaultValue: <String>[])
  final List<String> tag;
  String image;

  Map<String, dynamic> toJson() => _$HistoryMinResponseToJson(this);
}
