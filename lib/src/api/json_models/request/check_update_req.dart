import 'package:json_annotation/json_annotation.dart';

part 'check_update_req.g.dart';

@JsonSerializable()
class CheckUpdateRequest {
  @JsonKey(name: "parent_id")
  final String parentID;
  @JsonKey(name: "child_id")
  final String childID;
  @JsonKey(name: "checked_note")
  final String checkedNote;
  @JsonKey(name: "is_checked")
  final bool isChecked;
  @JsonKey(name: "have_problem")
  final bool haveProblem;
  @JsonKey(name: "complete_status")
  final int completeStatus;
  @JsonKey(name: "tag_selected")
  final String tagSelected;
  @JsonKey(name: "tag_extra_selected")
  final String tagExtraSelected;

  CheckUpdateRequest(
      {required this.parentID,
      required this.childID,
      required this.checkedNote,
      required this.isChecked,
      required this.haveProblem,
      required this.completeStatus,
      required this.tagSelected,
      required this.tagExtraSelected});

  factory CheckUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$CheckUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CheckUpdateRequestToJson(this);
}
