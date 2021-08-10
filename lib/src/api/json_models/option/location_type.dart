import 'package:json_annotation/json_annotation.dart';

part 'location_type.g.dart';

@JsonSerializable()
class OptLocationType {
  OptLocationType(this.location, this.type);

  factory OptLocationType.fromJson(Map<String, dynamic> json) =>
      _$OptLocationTypeFromJson(json);
  @JsonKey(defaultValue: <String>[])
  final List<String> location;
  @JsonKey(defaultValue: <String>[])
  final List<String> type;

  Map<String, dynamic> toJson() => _$OptLocationTypeToJson(this);
}
