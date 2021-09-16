import 'package:json_annotation/json_annotation.dart';
import 'config_check_resp.dart';

import 'error_resp.dart';

part 'config_check_list_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class ConfigCheckListResponse {
  ConfigCheckListResponse(this.error, this.data);

  factory ConfigCheckListResponse.fromJson(Map<String, dynamic> json) =>
      _$ConfigCheckListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigCheckListResponseToJson(this);

  final ErrorResp? error;
  @JsonKey(defaultValue: <ConfigCheckDetailResponseData>[])
  final List<ConfigCheckDetailResponseData> data;
}
