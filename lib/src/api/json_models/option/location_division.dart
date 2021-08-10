import 'package:json_annotation/json_annotation.dart';

part 'location_division.g.dart';

@JsonSerializable()
class OptLocationDivison {
  OptLocationDivison(this.location, this.division);

  factory OptLocationDivison.fromJson(Map<String, dynamic> json) =>
      _$OptLocationDivisonFromJson(json);
  @JsonKey(defaultValue: <String>[])
  final List<String> location;
  @JsonKey(defaultValue: <String>[])
  final List<String> division;

  Map<String, dynamic> toJson() => _$OptLocationDivisonToJson(this);
}
