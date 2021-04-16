import 'package:json_annotation/json_annotation.dart';

part 'location_type.g.dart';

@JsonSerializable()
class OptLocationType {
  @JsonKey(defaultValue: [])
  final List<String> location;
  @JsonKey(defaultValue: [])
  final List<String> type;

  OptLocationType(this.location, this.type);

  factory OptLocationType.fromJson(Map<String, dynamic> json) =>
      _$OptLocationTypeFromJson(json);

  Map<String, dynamic> toJson() => _$OptLocationTypeToJson(this);
}
