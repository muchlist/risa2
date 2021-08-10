import 'package:json_annotation/json_annotation.dart';

import 'error_resp.dart';

part 'check_list_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class CheckListResponse {
  CheckListResponse(this.error, this.data);

  factory CheckListResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckListResponseFromJson(json);

  final ErrorResp? error;
  @JsonKey(defaultValue: <CheckMinResponse>[])
  final List<CheckMinResponse> data;

  Map<String, dynamic> toJson() => _$CheckListResponseToJson(this);
}

@JsonSerializable()
class CheckMinResponse {
  CheckMinResponse(this.id, this.createdAt, this.createdBy, this.updatedAt,
      this.branch, this.shift, this.isFinish, this.note);

  factory CheckMinResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckMinResponseFromJson(json);

  final String id;
  @JsonKey(name: "created_at")
  final int createdAt;
  @JsonKey(name: "created_by")
  final String createdBy;
  @JsonKey(name: "updated_at")
  final int updatedAt;
  final String branch;
  final int shift;
  @JsonKey(name: "is_finish")
  final bool isFinish;
  final String note;

  Map<String, dynamic> toJson() => _$CheckMinResponseToJson(this);
}
