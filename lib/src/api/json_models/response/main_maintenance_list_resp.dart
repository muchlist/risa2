import 'package:json_annotation/json_annotation.dart';

import 'error_resp.dart';

part 'main_maintenance_list_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class MainMaintenanceListResponse {
  MainMaintenanceListResponse(this.error, this.data);

  factory MainMaintenanceListResponse.fromJson(Map<String, dynamic> json) =>
      _$MainMaintenanceListResponseFromJson(json);

  final ErrorResp? error;
  @JsonKey(defaultValue: <MainMaintMinResponse>[])
  final List<MainMaintMinResponse> data;

  Map<String, dynamic> toJson() => _$MainMaintenanceListResponseToJson(this);
}

@JsonSerializable()
class MainMaintMinResponse {
  MainMaintMinResponse(
      this.id,
      this.quarterlyMode,
      this.name,
      this.createdAt,
      this.createdBy,
      this.updatedAt,
      this.updatedBy,
      this.branch,
      this.timeStarted,
      this.timeEnded,
      this.isFinish,
      this.note);

  factory MainMaintMinResponse.fromJson(Map<String, dynamic> json) =>
      _$MainMaintMinResponseFromJson(json);

  final String id;
  @JsonKey(name: "quarterly_mode")
  final bool quarterlyMode;
  final String name;
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
  @JsonKey(name: "is_finish")
  final bool isFinish;
  final String note;

  Map<String, dynamic> toJson() => _$MainMaintMinResponseToJson(this);
}
