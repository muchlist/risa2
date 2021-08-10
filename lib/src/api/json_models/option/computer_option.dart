import 'package:json_annotation/json_annotation.dart';

part 'computer_option.g.dart';

@JsonSerializable()
class OptComputerType {
  OptComputerType(this.location, this.division, this.os, this.processor,
      this.hardisk, this.ram, this.type);

  factory OptComputerType.fromJson(Map<String, dynamic> json) =>
      _$OptComputerTypeFromJson(json);

  @JsonKey(defaultValue: <String>[])
  final List<String> location;
  @JsonKey(defaultValue: <String>[])
  final List<String> division;
  @JsonKey(defaultValue: <String>[])
  final List<String> os;
  @JsonKey(defaultValue: <String>[])
  final List<String> processor;
  @JsonKey(defaultValue: <int>[])
  final List<int> hardisk;
  @JsonKey(defaultValue: <int>[])
  final List<int> ram;
  @JsonKey(defaultValue: <String>[])
  final List<String> type;

  Map<String, dynamic> toJson() => _$OptComputerTypeToJson(this);
}
