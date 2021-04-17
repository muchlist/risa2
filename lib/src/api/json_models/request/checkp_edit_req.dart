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
  @JsonKey(name: "tag", defaultValue: [])
  final List<String> tag;
  @JsonKey(name: "tag_extra", defaultValue: [])
  final List<String> tagExtra;

  CheckpEditRequest(
      {required this.filterTimestamp,
      required this.name,
      required this.location,
      required this.note,
      required this.shifts,
      required this.type,
      required this.tag,
      required this.tagExtra});

  factory CheckpEditRequest.fromJson(Map<String, dynamic> json) =>
      _$CheckpEditRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CheckpEditRequestToJson(this);
}
