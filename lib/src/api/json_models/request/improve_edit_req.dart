import 'package:json_annotation/json_annotation.dart';

part 'improve_edit_req.g.dart';

@JsonSerializable()
class ImproveEditRequest {
  @JsonKey(name: "filter_timestamp")
  final int filterTimestamp;
  final String title;
  final String description;
  final int goal;
  @JsonKey(name: "complete_status")
  final int completeStatus;

  ImproveEditRequest(
      {required this.filterTimestamp,
      required this.title,
      required this.description,
      required this.goal,
      required this.completeStatus});

  factory ImproveEditRequest.fromJson(Map<String, dynamic> json) =>
      _$ImproveEditRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ImproveEditRequestToJson(this);
}
