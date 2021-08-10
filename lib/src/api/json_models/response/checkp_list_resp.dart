import 'package:json_annotation/json_annotation.dart';

import 'error_resp.dart';

part 'checkp_list_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class CheckpListResponse {
  CheckpListResponse(this.error, this.data);

  factory CheckpListResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckpListResponseFromJson(json);

  final ErrorResp? error;
  @JsonKey(defaultValue: <CheckpMinResponse>[])
  final List<CheckpMinResponse> data;

  Map<String, dynamic> toJson() => _$CheckpListResponseToJson(this);
}

@JsonSerializable()
class CheckpMinResponse {
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

  final String id;
  final String branch;
  final bool disable;
  final String name;
  final String location;
  final String type;
  final String note;
  @JsonKey(defaultValue: <int>[])
  final List<int> shifts;
  @JsonKey(defaultValue: <String>[])
  final List<String> tag;
  @JsonKey(defaultValue: <String>[])
  final List<String> tagExtra;
  @JsonKey(name: "checked_note")
  final String checkedNote;
  @JsonKey(name: "have_problem")
  final bool haveProblem;
  @JsonKey(name: "complete_status")
  final int completeStatus;

  Map<String, dynamic> toJson() => _$CheckpMinResponseToJson(this);
}
