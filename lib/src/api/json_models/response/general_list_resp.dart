import 'package:json_annotation/json_annotation.dart';

import 'error_resp.dart';

part 'general_list_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class GeneralListResponse {
  final ErrorResp? error;
  @JsonKey(defaultValue: [])
  final List<GeneralMinResponse> data;

  GeneralListResponse(this.error, this.data);

  factory GeneralListResponse.fromJson(Map<String, dynamic> json) =>
      _$GeneralListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GeneralListResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GeneralMinResponse {
  final String id;
  final String category;
  final String name;
  final String ip;
  final String branch;
  @JsonKey(defaultValue: [])
  final List<Case> cases;
  @JsonKey(name: "cases_size")
  final int casesSize;
  @JsonKey(name: "pings_state", defaultValue: [])
  final List<PingState> pingsState;
  @JsonKey(name: "last_ping")
  final String lastPing;

  GeneralMinResponse(this.id, this.category, this.name, this.ip, this.branch,
      this.cases, this.casesSize, this.pingsState, this.lastPing);

  factory GeneralMinResponse.fromJson(Map<String, dynamic> json) =>
      _$GeneralMinResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GeneralMinResponseToJson(this);
}

@JsonSerializable()
class PingState {
  final int code;
  final int time;
  final String status;

  PingState(this.code, this.time, this.status);

  factory PingState.fromJson(Map<String, dynamic> json) =>
      _$PingStateFromJson(json);

  Map<String, dynamic> toJson() => _$PingStateToJson(this);
}

@JsonSerializable()
class Case {
  @JsonKey(name: "case_id")
  final String caseId;
  @JsonKey(name: "case_note")
  final String caseNote;

  Case(this.caseId, this.caseNote);

  factory Case.fromJson(Map<String, dynamic> json) => _$CaseFromJson(json);

  Map<String, dynamic> toJson() => _$CaseToJson(this);
}
