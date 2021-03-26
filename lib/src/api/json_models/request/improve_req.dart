import 'package:json_annotation/json_annotation.dart';

part 'improve_req.g.dart';

@JsonSerializable()
class ImproveRequest {
  final String title;
  final String description;
  final int goal;
  @JsonKey(name: "complete_status")
  final int completeStatus;

  ImproveRequest(
      {required this.title,
      required this.description,
      required this.goal,
      required this.completeStatus});

  factory ImproveRequest.fromJson(Map<String, dynamic> json) =>
      _$ImproveRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ImproveRequestToJson(this);
}
