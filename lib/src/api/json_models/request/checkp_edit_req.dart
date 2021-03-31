import 'package:json_annotation/json_annotation.dart';

part 'checkp_edit_req.g.dart';

@JsonSerializable()
class CheckpEditRequest {
  @JsonKey(name: "filter_timestamp")
  final int filterTimestamp;
  final String name;
  final String location;
  final String note;
  @JsonKey(defaultValue: [])
  final List<int> shifts;
  final String type;
  @JsonKey(name: "tag_one", defaultValue: [])
  final List<String> tagOne;
  @JsonKey(name: "tag_two", defaultValue: [])
  final List<String> tagTwo;

  CheckpEditRequest(this.filterTimestamp, this.name, this.location, this.note,
      this.shifts, this.type, this.tagOne, this.tagTwo);

  factory CheckpEditRequest.fromJson(Map<String, dynamic> json) =>
      _$CheckpEditRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CheckpEditRequestToJson(this);
}
