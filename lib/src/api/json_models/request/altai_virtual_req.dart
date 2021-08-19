import 'package:json_annotation/json_annotation.dart';

part 'altai_virtual_req.g.dart';

@JsonSerializable()
class AltaiVirtualUpdateRequest {
  AltaiVirtualUpdateRequest({
    required this.parentID,
    required this.childID,
    required this.isChecked,
    required this.isOffline,
  });

  factory AltaiVirtualUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$AltaiVirtualUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AltaiVirtualUpdateRequestToJson(this);

  @JsonKey(name: "parent_id")
  final String parentID;
  @JsonKey(name: "child_id")
  final String childID;
  @JsonKey(name: "is_checked")
  bool isChecked;
  @JsonKey(name: "is_offline")
  bool isOffline;
}

@JsonSerializable(explicitToJson: true)
@JsonSerializable()
class BulkVendorUpdateRequest {
  BulkVendorUpdateRequest(this.items);

  factory BulkVendorUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$BulkVendorUpdateRequestFromJson(json);
  final List<AltaiVirtualUpdateRequest> items;

  Map<String, dynamic> toJson() => _$BulkVendorUpdateRequestToJson(this);
}
