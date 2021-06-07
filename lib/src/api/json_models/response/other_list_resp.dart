import 'package:json_annotation/json_annotation.dart';
import 'package:risa2/src/api/json_models/response/general_list_resp.dart';

import 'error_resp.dart';

part 'other_list_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class OtherListResponse {
  final ErrorResp? error;
  final OtherListData data;

  OtherListResponse(this.error, this.data);

  factory OtherListResponse.fromJson(Map<String, dynamic> json) =>
      _$OtherListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OtherListResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class OtherListData {
  @JsonKey(defaultValue: [], name: "other_list")
  final List<OtherMinResponse> otherList;
  @JsonKey(defaultValue: [], name: "extra_list")
  final List<GeneralMinResponse> extraList;

  OtherListData(this.otherList, this.extraList);

  factory OtherListData.fromJson(Map<String, dynamic> json) =>
      _$OtherListDataFromJson(json);

  Map<String, dynamic> toJson() => _$OtherListDataToJson(this);
}

@JsonSerializable()
class OtherMinResponse {
  @JsonKey(name: "sub_category")
  final String subCategory;
  final String id;
  final String branch;
  final bool disable;
  final String name;
  final String detail;
  final String division;
  final String ip;
  final String location;
  @JsonKey(defaultValue: [])
  final List<String> tag;

  OtherMinResponse(
    this.subCategory,
    this.id,
    this.branch,
    this.disable,
    this.name,
    this.detail,
    this.division,
    this.ip,
    this.location,
    this.tag,
  );

  factory OtherMinResponse.fromJson(Map<String, dynamic> json) =>
      _$OtherMinResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OtherMinResponseToJson(this);
}
