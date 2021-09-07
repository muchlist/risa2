import 'package:json_annotation/json_annotation.dart';

import 'error_resp.dart';
import 'server_config_resp.dart';

part 'server_config_list_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class ServerConfigListResponse {
  ServerConfigListResponse(this.error, this.data);

  factory ServerConfigListResponse.fromJson(Map<String, dynamic> json) =>
      _$ServerConfigListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ServerConfigListResponseToJson(this);

  final ErrorResp? error;
  @JsonKey(defaultValue: <ServerConfigResponse>[])
  final List<ServerConfigResponse> data;
}
