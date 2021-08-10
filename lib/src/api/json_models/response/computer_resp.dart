import 'package:json_annotation/json_annotation.dart';

import 'error_resp.dart';
import 'general_list_resp.dart';

part 'computer_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class ComputerDetailResponse {
  ComputerDetailResponse(this.error, this.data);

  factory ComputerDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$ComputerDetailResponseFromJson(json);

  final ErrorResp? error;
  final ComputerDetailResponseData? data;

  Map<String, dynamic> toJson() => _$ComputerDetailResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ComputerDetailResponseData {
  ComputerDetailResponseData(
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
      this.hostname,
      this.ip,
      this.inventoryNumber,
      this.location,
      this.locationLat,
      this.locationLon,
      this.division,
      this.seatManagement,
      this.os,
      this.processor,
      this.ram,
      this.hardisk,
      this.date,
      this.tag,
      this.image,
      this.brand,
      this.type,
      this.note,
      this.extra);

  factory ComputerDetailResponseData.fromJson(Map<String, dynamic> json) =>
      _$ComputerDetailResponseDataFromJson(json);

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
  final String hostname;
  final String ip;
  @JsonKey(name: "inventory_number")
  final String inventoryNumber;
  final String location;
  @JsonKey(name: "location_lat")
  final String locationLat;
  @JsonKey(name: "location_lon")
  final String locationLon;
  final String division;
  @JsonKey(name: "seat_management")
  final bool seatManagement;
  final String os;
  final String processor;
  final int ram;
  final int hardisk;
  final int date;
  @JsonKey(defaultValue: <String>[])
  final List<String> tag;
  final String image;
  final String brand;
  final String type;
  final String note;
  final ComputerExtra extra;

  Map<String, dynamic> toJson() => _$ComputerDetailResponseDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ComputerExtra {
  ComputerExtra(this.cases, this.casesSize, this.pingsState, this.lastPing);

  factory ComputerExtra.fromJson(Map<String, dynamic> json) =>
      _$ComputerExtraFromJson(json);

  @JsonKey(defaultValue: <Case>[])
  final List<Case> cases;
  @JsonKey(name: "cases_size")
  final int casesSize;
  @JsonKey(name: "pings_state", defaultValue: <PingState>[])
  final List<PingState> pingsState;
  @JsonKey(name: "last_ping")
  final String lastPing;

  Map<String, dynamic> toJson() => _$ComputerExtraToJson(this);
}
