import 'package:json_annotation/json_annotation.dart';

import 'error_resp.dart';

part 'speed_list_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class SpeedListResponse {
  final ErrorResp? error;
  @JsonKey(defaultValue: [])
  final List<SpeedData> data;

  SpeedListResponse(this.error, this.data);

  factory SpeedListResponse.fromJson(Map<String, dynamic> json) =>
      _$SpeedListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SpeedListResponseToJson(this);
}

@JsonSerializable()
class SpeedData {
  final int time;
  @JsonKey(name: "latency_ms")
  final int latencyMs;
  final double upload;
  final double download;

  SpeedData(this.time, this.latencyMs, this.upload, this.download);

  factory SpeedData.fromJson(Map<String, dynamic> json) =>
      _$SpeedDataFromJson(json);

  Map<String, dynamic> toJson() => _$SpeedDataToJson(this);
}
