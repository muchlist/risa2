import 'package:json_annotation/json_annotation.dart';

part 'improve_change_req.g.dart';

@JsonSerializable()
class ImproveChangeRequest {
  final int increment;
  final String note;
  final int time;

  ImproveChangeRequest(
      {required this.increment, required this.note, required this.time});

  factory ImproveChangeRequest.fromJson(Map<String, dynamic> json) =>
      _$ImproveChangeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ImproveChangeRequestToJson(this);
}
