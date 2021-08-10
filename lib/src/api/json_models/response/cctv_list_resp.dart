import 'package:json_annotation/json_annotation.dart';
import 'package:risa2/src/api/json_models/response/general_list_resp.dart';

import 'error_resp.dart';

part 'cctv_list_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class CctvListResponse {
  CctvListResponse(this.error, this.data);

  factory CctvListResponse.fromJson(Map<String, dynamic> json) =>
      _$CctvListResponseFromJson(json);
  final ErrorResp? error;
  final CctvListData data;

  Map<String, dynamic> toJson() => _$CctvListResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CctvListData {
  CctvListData(this.cctvList, this.extraList);

  factory CctvListData.fromJson(Map<String, dynamic> json) =>
      _$CctvListDataFromJson(json);
  @JsonKey(defaultValue: [], name: "cctv_list")
  final List<CctvMinResponse> cctvList;
  @JsonKey(defaultValue: [], name: "extra_list")
  final List<GeneralMinResponse> extraList;

  Map<String, dynamic> toJson() => _$CctvListDataToJson(this);
}

@JsonSerializable()
class CctvMinResponse {
  CctvMinResponse(this.id, this.branch, this.disable, this.name, this.ip,
      this.location, this.tag);

  factory CctvMinResponse.fromJson(Map<String, dynamic> json) =>
      _$CctvMinResponseFromJson(json);

  final String id;
  final String branch;
  final bool disable;
  final String name;
  final String ip;
  final String location;
  @JsonKey(defaultValue: [])
  final List<String> tag;

  Map<String, dynamic> toJson() => _$CctvMinResponseToJson(this);
}
