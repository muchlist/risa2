import 'package:json_annotation/json_annotation.dart';

part 'location_division.g.dart';

@JsonSerializable()
class OptLocationDivison {
  @JsonKey(defaultValue: [])
  final List<String> location;
  @JsonKey(defaultValue: [])
  final List<String> division;

  OptLocationDivison(this.location, this.division);

  factory OptLocationDivison.fromJson(Map<String, dynamic> json) =>
      _$OptLocationDivisonFromJson(json);

  Map<String, dynamic> toJson() => _$OptLocationDivisonToJson(this);
}
