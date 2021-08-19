import 'package:json_annotation/json_annotation.dart';

part 'cctv_maintenance_req.g.dart';

@JsonSerializable()
class CCTVMaintUpdateRequest {
  CCTVMaintUpdateRequest({
    required this.parentID,
    required this.childID,
    required this.isChecked,
    required this.isMaintained,
    required this.isBlur,
    required this.isOffline,
  });

  factory CCTVMaintUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$CCTVMaintUpdateRequestFromJson(json);

  @JsonKey(name: "parent_id")
  final String parentID;
  @JsonKey(name: "child_id")
  final String childID;
  @JsonKey(name: "is_checked")
  bool isChecked;
  @JsonKey(name: "is_maintained")
  bool isMaintained;
  @JsonKey(name: "is_blur")
  bool isBlur;
  @JsonKey(name: "is_offline")
  bool isOffline;

  Map<String, dynamic> toJson() => _$CCTVMaintUpdateRequestToJson(this);
}

@JsonSerializable(explicitToJson: true)
@JsonSerializable()
class BulkCCTVMaintUpdateRequest {
  BulkCCTVMaintUpdateRequest(this.items);

  factory BulkCCTVMaintUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$BulkCCTVMaintUpdateRequestFromJson(json);
  final List<CCTVMaintUpdateRequest> items;

  Map<String, dynamic> toJson() => _$BulkCCTVMaintUpdateRequestToJson(this);
}
