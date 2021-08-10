import 'package:json_annotation/json_annotation.dart';

import 'error_resp.dart';
import 'general_list_resp.dart';

part 'cctv_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class CctvDetailResponse {
  CctvDetailResponse(this.error, this.data);

  factory CctvDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$CctvDetailResponseFromJson(json);

  final ErrorResp? error;
  final CctvDetailResponseData? data;

  Map<String, dynamic> toJson() => _$CctvDetailResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CctvDetailResponseData {
  CctvDetailResponseData(
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
      this.ip,
      this.inventoryNumber,
      this.location,
      this.locationLat,
      this.locationLon,
      this.date,
      this.tag,
      this.image,
      this.brand,
      this.type,
      this.note,
      this.extra);

  factory CctvDetailResponseData.fromJson(Map<String, dynamic> json) =>
      _$CctvDetailResponseDataFromJson(json);

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
  final String ip;
  @JsonKey(name: "inventory_number")
  final String inventoryNumber;
  final String location;
  @JsonKey(name: "location_lat")
  final String locationLat;
  @JsonKey(name: "location_lon")
  final String locationLon;
  final int date;
  @JsonKey(defaultValue: [])
  final List<String> tag;
  final String image;
  final String brand;
  final String type;
  final String note;
  final CctvExtra extra;

  Map<String, dynamic> toJson() => _$CctvDetailResponseDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CctvExtra {
  @JsonKey(defaultValue: [])
  final List<Case> cases;
  @JsonKey(name: "cases_size")
  final int casesSize;
  @JsonKey(name: "pings_state", defaultValue: [])
  final List<PingState> pingsState;
  @JsonKey(name: "last_ping")
  final String lastPing;

  CctvExtra(this.cases, this.casesSize, this.pingsState, this.lastPing);

  factory CctvExtra.fromJson(Map<String, dynamic> json) =>
      _$CctvExtraFromJson(json);

  Map<String, dynamic> toJson() => _$CctvExtraToJson(this);
}
