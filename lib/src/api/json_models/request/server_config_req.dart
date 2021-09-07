import 'package:json_annotation/json_annotation.dart';

part 'server_config_req.g.dart';

@JsonSerializable()
class ServerConfigRequest {
  ServerConfigRequest({
    required this.title,
    required this.note,
    required this.diff,
    required this.image,
  });

  factory ServerConfigRequest.fromJson(Map<String, dynamic> json) =>
      _$ServerConfigRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ServerConfigRequestToJson(this);

  final String title;
  final String note;
  final String diff;
  final String image;
}
