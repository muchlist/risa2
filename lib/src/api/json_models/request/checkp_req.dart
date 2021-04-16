import 'package:json_annotation/json_annotation.dart';

part 'checkp_req.g.dart';

@JsonSerializable()
class CheckpRequest {
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

  CheckpRequest(
      {required this.name,
      required this.location,
      required this.note,
      required this.shifts,
      required this.type,
      required this.tag,
      required this.tagExtra});

  factory CheckpRequest.fromJson(Map<String, dynamic> json) =>
      _$CheckpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CheckpRequestToJson(this);
}
