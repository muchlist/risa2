import 'package:json_annotation/json_annotation.dart';

part 'history_edit_req.g.dart';

@JsonSerializable()
class HistoryEditRequest {
  @JsonKey(name: "filter_timestamp")
  final int filterTimestamp;
  final String problem;
  @JsonKey(name: "problem_resolve")
  final int problemResolve;
  final String status;
  @JsonKey(defaultValue: [])
  final List<String> tag;
  @JsonKey(name: "complete_status")
  final int completeStatus;
  @JsonKey(name: "date_end")
  final int dateEnd;

  HistoryEditRequest(
      {required this.filterTimestamp,
      required this.problem,
      required this.problemResolve,
      required this.status,
      required this.tag,
      required this.completeStatus,
      required this.dateEnd});

  factory HistoryEditRequest.fromJson(Map<String, dynamic> json) =>
      _$HistoryEditRequestFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryEditRequestToJson(this);
}
