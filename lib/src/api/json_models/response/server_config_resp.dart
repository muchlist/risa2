import 'package:json_annotation/json_annotation.dart';

import 'error_resp.dart';

part 'server_config_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class ServerConfigDetailResponse {
  ServerConfigDetailResponse(this.error, this.data);

  factory ServerConfigDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$ServerConfigDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ServerConfigDetailResponseToJson(this);

  final ErrorResp? error;
  final ServerConfigResponse? data;
}

@JsonSerializable()
class ServerConfigResponse {
  ServerConfigResponse(this.id, this.updatedBy, this.updatedAt, this.branch,
      this.title, this.note, this.diff, this.image);

  factory ServerConfigResponse.fromJson(Map<String, dynamic> json) =>
      _$ServerConfigResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ServerConfigResponseToJson(this);

  final String id;
  @JsonKey(name: "updated_by")
  final String updatedBy;
  @JsonKey(name: "updated_at")
  final int updatedAt;
  final String branch;
  final String title;
  final String note;
  final String diff;
  final String image;
}
