import 'package:json_annotation/json_annotation.dart';

part 'altai_maintenance_req.g.dart';

@JsonSerializable()
class AltaiMaintUpdateRequest {
  AltaiMaintUpdateRequest({
    required this.parentID,
    required this.childID,
    required this.isChecked,
    required this.isMaintained,
    required this.isOffline,
  });

  factory AltaiMaintUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$AltaiMaintUpdateRequestFromJson(json);

  @JsonKey(name: "parent_id")
  final String parentID;
  @JsonKey(name: "child_id")
  final String childID;
  @JsonKey(name: "is_checked")
  bool isChecked;
  @JsonKey(name: "is_maintained")
  bool isMaintained;
  @JsonKey(name: "is_offline")
  bool isOffline;

  Map<String, dynamic> toJson() => _$AltaiMaintUpdateRequestToJson(this);
}

@JsonSerializable(explicitToJson: true)
@JsonSerializable()
class BulkAltaiMaintUpdateRequest {
  BulkAltaiMaintUpdateRequest(this.items);

  factory BulkAltaiMaintUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$BulkAltaiMaintUpdateRequestFromJson(json);
  final List<AltaiMaintUpdateRequest> items;

  Map<String, dynamic> toJson() => _$BulkAltaiMaintUpdateRequestToJson(this);
}
