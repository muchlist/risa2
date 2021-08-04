import 'package:json_annotation/json_annotation.dart';

part 'history_req.g.dart';

@JsonSerializable()
class HistoryRequest {
  final String id; // mengisi ID jika hanya ingin menyamakan dengan ID gambar
  @JsonKey(name: "parent_id")
  final String parentID;
  final String problem;
  @JsonKey(name: "problem_resolve")
  final String problemResolve;
  final String status;
  @JsonKey(defaultValue: [])
  final List<String> tag;
  @JsonKey(name: "complete_status")
  final int completeStatus;
  final String image;

  HistoryRequest(
      {required this.id,
      required this.parentID,
      required this.problem,
      required this.problemResolve,
      required this.status,
      required this.tag,
      required this.completeStatus,
      required this.image});

  factory HistoryRequest.fromJson(Map<String, dynamic> json) =>
      _$HistoryRequestFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryRequestToJson(this);
}
