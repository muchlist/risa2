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
  @JsonKey(name: "tag_one", defaultValue: [])
  final List<String> tagOne;
  @JsonKey(name: "tag_two", defaultValue: [])
  final List<String> tagTwo;

  CheckpRequest(this.name, this.location, this.note, this.shifts, this.type,
      this.tagOne, this.tagTwo);

  factory CheckpRequest.fromJson(Map<String, dynamic> json) =>
      _$CheckpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CheckpRequestToJson(this);
}
