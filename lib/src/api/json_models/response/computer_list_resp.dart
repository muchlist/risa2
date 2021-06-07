import 'package:json_annotation/json_annotation.dart';
import 'package:risa2/src/api/json_models/response/general_list_resp.dart';

import 'error_resp.dart';

part 'computer_list_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class ComputerListResponse {
  final ErrorResp? error;
  final ComputerListData data;

  ComputerListResponse(this.error, this.data);

  factory ComputerListResponse.fromJson(Map<String, dynamic> json) =>
      _$ComputerListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ComputerListResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ComputerListData {
  @JsonKey(defaultValue: [], name: "computer_list")
  final List<ComputerMinResponse> computerList;
  @JsonKey(defaultValue: [], name: "extra_list")
  final List<GeneralMinResponse> extraList;

  ComputerListData(this.computerList, this.extraList);

  factory ComputerListData.fromJson(Map<String, dynamic> json) =>
      _$ComputerListDataFromJson(json);

  Map<String, dynamic> toJson() => _$ComputerListDataToJson(this);
}

@JsonSerializable()
class ComputerMinResponse {
  final String id;
  final String branch;
  final bool disable;
  final String name;
  final String division;
  @JsonKey(name: "seat_management")
  final bool seatManagement;
  final String ip;
  final String location;
  @JsonKey(defaultValue: [])
  final List<String> tag;

  ComputerMinResponse(
    this.id,
    this.branch,
    this.disable,
    this.name,
    this.division,
    this.seatManagement,
    this.ip,
    this.location,
    this.tag,
  );

  factory ComputerMinResponse.fromJson(Map<String, dynamic> json) =>
      _$ComputerMinResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ComputerMinResponseToJson(this);
}
