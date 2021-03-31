import 'package:json_annotation/json_annotation.dart';

import 'error_resp.dart';

part 'checkp_list_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class CheckpListResponse {
  final ErrorResp? error;
  @JsonKey(defaultValue: [])
  final List<CheckpMinResponse> data;

  CheckpListResponse(this.error, this.data);

  factory CheckpListResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckpListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CheckpListResponseToJson(this);
}

@JsonSerializable()
class CheckpMinResponse {
  final String id;
  final String branch;
  final bool disable;
  final String name;
  final String location;
  final String type;
  final String note;
  @JsonKey(defaultValue: [])
  final List<int> shifts;
  @JsonKey(defaultValue: [])
  final List<String> tag;
  @JsonKey(defaultValue: [])
  final List<String> tagExtra;
  @JsonKey(name: "checked_note")
  final String checkedNote;
  @JsonKey(name: "have_problem")
  final bool haveProblem;
  @JsonKey(name: "complete_status")
  final int completeStatus;

  CheckpMinResponse(
      this.id,
      this.branch,
      this.disable,
      this.name,
      this.location,
      this.type,
      this.note,
      this.shifts,
      this.tag,
      this.tagExtra,
      this.checkedNote,
      this.haveProblem,
      this.completeStatus);

  factory CheckpMinResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckpMinResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CheckpMinResponseToJson(this);
}
