import 'package:json_annotation/json_annotation.dart';

part 'vendor_req.g.dart';

@JsonSerializable()
class VendorUpdateRequest {
  VendorUpdateRequest({
    required this.parentID,
    required this.childID,
    required this.isChecked,
    required this.isBlur,
    required this.isOffline,
  });

  @JsonKey(name: "parent_id")
  final String parentID;
  @JsonKey(name: "child_id")
  final String childID;
  @JsonKey(name: "is_checked")
  bool isChecked;
  @JsonKey(name: "is_blur")
  bool isBlur;
  @JsonKey(name: "is_offline")
  bool isOffline;

  factory VendorUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$VendorUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$VendorUpdateRequestToJson(this);
}

@JsonSerializable(explicitToJson: true)
@JsonSerializable()
class BulkVendorUpdateRequest {
  BulkVendorUpdateRequest(this.items);
  final List<VendorUpdateRequest> items;

  factory BulkVendorUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$BulkVendorUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$BulkVendorUpdateRequestToJson(this);
}
