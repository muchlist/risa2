import 'package:json_annotation/json_annotation.dart';

part 'check_edit_req.g.dart';

@JsonSerializable()
class CheckEditRequest {
  @JsonKey(name: "is_finish")
  final bool isFinish;
  final String note;
  CheckEditRequest({required this.isFinish, required this.note});

  factory CheckEditRequest.fromJson(Map<String, dynamic> json) =>
      _$CheckEditRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CheckEditRequestToJson(this);
}
