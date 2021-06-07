import 'package:json_annotation/json_annotation.dart';

import 'error_resp.dart';
import 'general_list_resp.dart';

part 'other_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class OtherDetailResponse {
  final ErrorResp? error;
  final OtherDetailResponseData? data;

  OtherDetailResponse(this.error, this.data);

  factory OtherDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$OtherDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OtherDetailResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class OtherDetailResponseData {
  @JsonKey(name: "sub_category")
  final String subCategory;
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
  final bool disable;
  final String name;
  final String detail;
  final String ip;
  @JsonKey(name: "inventory_number")
  final String inventoryNumber;
  final String location;
  @JsonKey(name: "location_lat")
  final String locationLat;
  @JsonKey(name: "location_lon")
  final String locationLon;
  final String division;
  final int date;
  @JsonKey(defaultValue: [])
  final List<String> tag;
  final String image;
  final String brand;
  final String type;
  final String note;
  final OtherExtra extra;

  OtherDetailResponseData(
      this.subCategory,
      this.id,
      this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.createdById,
      this.updatedBy,
      this.updatedById,
      this.branch,
      this.disable,
      this.name,
      this.detail,
      this.ip,
      this.inventoryNumber,
      this.location,
      this.locationLat,
      this.locationLon,
      this.division,
      this.date,
      this.tag,
      this.image,
      this.brand,
      this.type,
      this.note,
      this.extra);

  factory OtherDetailResponseData.fromJson(Map<String, dynamic> json) =>
      _$OtherDetailResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$OtherDetailResponseDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class OtherExtra {
  @JsonKey(defaultValue: [])
  final List<Case> cases;
  @JsonKey(name: "cases_size")
  final int casesSize;
  @JsonKey(name: "pings_state", defaultValue: [])
  final List<PingState> pingsState;
  @JsonKey(name: "last_ping")
  final String lastPing;

  OtherExtra(this.cases, this.casesSize, this.pingsState, this.lastPing);

  factory OtherExtra.fromJson(Map<String, dynamic> json) =>
      _$OtherExtraFromJson(json);

  Map<String, dynamic> toJson() => _$OtherExtraToJson(this);
}
