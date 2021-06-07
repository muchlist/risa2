import 'package:json_annotation/json_annotation.dart';

part 'computer_option.g.dart';

@JsonSerializable()
class OptComputerType {
  @JsonKey(defaultValue: [])
  final List<String> location;
  @JsonKey(defaultValue: [])
  final List<String> division;
  @JsonKey(defaultValue: [])
  final List<String> os;
  @JsonKey(defaultValue: [])
  final List<String> processor;
  @JsonKey(defaultValue: [])
  final List<int> hardisk;
  @JsonKey(defaultValue: [])
  final List<int> ram;
  @JsonKey(defaultValue: [])
  final List<String> type;

  OptComputerType(this.location, this.division, this.os, this.processor,
      this.hardisk, this.ram, this.type);

  factory OptComputerType.fromJson(Map<String, dynamic> json) =>
      _$OptComputerTypeFromJson(json);

  Map<String, dynamic> toJson() => _$OptComputerTypeToJson(this);
}
