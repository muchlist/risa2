import 'package:json_annotation/json_annotation.dart';

import 'error_resp.dart';

part 'general_list_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class GeneralListResponse {
  GeneralListResponse(this.error, this.data);

  factory GeneralListResponse.fromJson(Map<String, dynamic> json) =>
      _$GeneralListResponseFromJson(json);

  final ErrorResp? error;
  @JsonKey(defaultValue: <GeneralMinResponse>[])
  final List<GeneralMinResponse> data;

  Map<String, dynamic> toJson() => _$GeneralListResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GeneralMinResponse {
  GeneralMinResponse(this.id, this.category, this.name, this.ip, this.branch,
      this.cases, this.casesSize, this.pingsState, this.lastPing);

  factory GeneralMinResponse.fromJson(Map<String, dynamic> json) =>
      _$GeneralMinResponseFromJson(json);

  final String id;
  final String category;
  final String name;
  final String ip;
  final String branch;
  @JsonKey(defaultValue: <Case>[])
  final List<Case> cases;
  @JsonKey(name: "cases_size")
  final int casesSize;
  @JsonKey(name: "pings_state", defaultValue: <PingState>[])
  final List<PingState> pingsState;
  @JsonKey(name: "last_ping")
  final String lastPing;

  Map<String, dynamic> toJson() => _$GeneralMinResponseToJson(this);
}

@JsonSerializable()
class PingState {
  PingState(this.code, this.time, this.status);

  factory PingState.fromJson(Map<String, dynamic> json) =>
      _$PingStateFromJson(json);
  final int code;
  final int time;
  final String status;

  Map<String, dynamic> toJson() => _$PingStateToJson(this);
}

@JsonSerializable()
class Case {
  Case(this.caseId, this.caseNote);

  factory Case.fromJson(Map<String, dynamic> json) => _$CaseFromJson(json);

  @JsonKey(name: "case_id")
  final String caseId;
  @JsonKey(name: "case_note")
  final String caseNote;

  Map<String, dynamic> toJson() => _$CaseToJson(this);
}
