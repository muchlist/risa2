import 'package:json_annotation/json_annotation.dart';

import 'error_resp.dart';

part 'check_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class CheckDetailResponse {
  final ErrorResp? error;
  final CheckDetailResponseData? data;

  CheckDetailResponse(this.error, this.data);

  factory CheckDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CheckDetailResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CheckDetailResponseData {
  final String id;
  @JsonKey(name: "created_at")
  final int createdAt;
  @JsonKey(name: "updated_at")
  final int updatedAt;
  @JsonKey(name: "created_by")
  final String createdBy;
  @JsonKey(name: "created_by_id")
  final String createdById;
  @JsonKey(name: "updated_by")
  final String updatedBy;
  @JsonKey(name: "updated_by_id")
  final String updatedById;
  final String branch;
  final int shift;
  @JsonKey(name: "is_finish")
  final bool isFinish;
  final String note;
  @JsonKey(name: "check_items", defaultValue: [])
  final List<CheckItem> checkItems;

  CheckDetailResponseData(
      this.id,
      this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.createdById,
      this.updatedBy,
      this.updatedById,
      this.branch,
      this.shift,
      this.isFinish,
      this.note,
      this.checkItems);

  factory CheckDetailResponseData.fromJson(Map<String, dynamic> json) =>
      _$CheckDetailResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$CheckDetailResponseDataToJson(this);
}

@JsonSerializable()
class CheckItem {
  final String id;
  final String name;
  final String location;
  final String type;
  @JsonKey(defaultValue: [])
  final List<String> tag;
  @JsonKey(name: "tag_extra", defaultValue: [])
  final List<String> tagExtra;
  @JsonKey(name: "checked_at")
  final int checkedAt;
  @JsonKey(name: "tag_selected")
  final String tagSelected;
  @JsonKey(name: "tag_extra_selected")
  final String tagExtraSelected;
  @JsonKey(name: "image_path")
  final String imagePath;
  @JsonKey(name: "checked_note")
  final String checkedNote;
  @JsonKey(name: "have_problem")
  final bool haveProblem;
  @JsonKey(name: "complete_status")
  final int completeStatus;

  CheckItem(
      this.id,
      this.name,
      this.location,
      this.type,
      this.tag,
      this.tagExtra,
      this.checkedAt,
      this.tagSelected,
      this.tagExtraSelected,
      this.imagePath,
      this.checkedNote,
      this.haveProblem,
      this.completeStatus);

  factory CheckItem.fromJson(Map<String, dynamic> json) =>
      _$CheckItemFromJson(json);

  Map<String, dynamic> toJson() => _$CheckItemToJson(this);
}
