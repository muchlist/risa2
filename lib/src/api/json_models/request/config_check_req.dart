import 'package:json_annotation/json_annotation.dart';

part 'config_check_req.g.dart';

@JsonSerializable()
class ConfigCheckUpdateRequest {
  ConfigCheckUpdateRequest({
    required this.parentID,
    required this.childID,
    required this.isUpdated,
  });

  factory ConfigCheckUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$ConfigCheckUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigCheckUpdateRequestToJson(this);

  @JsonKey(name: "parent_id")
  final String parentID;
  @JsonKey(name: "child_id")
  final String childID;
  @JsonKey(name: "is_updated")
  bool isUpdated;
}

@JsonSerializable()
class ConfigCheckUpdateManyRequest {
  ConfigCheckUpdateManyRequest({
    required this.parentID,
    required this.childUpdate,
    required this.childNotUpdate,
  });

  factory ConfigCheckUpdateManyRequest.fromJson(Map<String, dynamic> json) =>
      _$ConfigCheckUpdateManyRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigCheckUpdateManyRequestToJson(this);

  @JsonKey(name: "parent_id")
  final String parentID;
  @JsonKey(name: "child_update")
  final List<String> childUpdate;
  @JsonKey(name: "child_not_updated")
  final List<String> childNotUpdate;
}
