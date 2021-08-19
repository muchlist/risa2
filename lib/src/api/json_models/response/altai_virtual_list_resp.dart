import 'package:json_annotation/json_annotation.dart';

import 'error_resp.dart';

part 'altai_virtual_list_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class AltaiVirtualListResponse {
  AltaiVirtualListResponse(this.error, this.data);

  factory AltaiVirtualListResponse.fromJson(Map<String, dynamic> json) =>
      _$AltaiVirtualListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AltaiVirtualListResponseToJson(this);

  final ErrorResp? error;
  @JsonKey(defaultValue: <AltaiVirtualMinResponse>[])
  final List<AltaiVirtualMinResponse> data;
}

@JsonSerializable()
class AltaiVirtualMinResponse {
  AltaiVirtualMinResponse(
      this.id,
      this.createdAt,
      this.createdBy,
      this.updatedAt,
      this.updatedBy,
      this.branch,
      this.timeStarted,
      this.timeEnded,
      this.isFinish,
      this.note);

  factory AltaiVirtualMinResponse.fromJson(Map<String, dynamic> json) =>
      _$AltaiVirtualMinResponseFromJson(json);

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
  @JsonKey(name: "is_finish")
  final bool isFinish;
  final String note;

  Map<String, dynamic> toJson() => _$AltaiVirtualMinResponseToJson(this);
}
