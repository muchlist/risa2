import 'package:json_annotation/json_annotation.dart';
part 'error_resp.g.dart';

@JsonSerializable()
class ErrorResp {
  ErrorResp(this.status, this.message, this.error, this.causes);

  factory ErrorResp.fromJson(Map<String, dynamic> json) =>
      _$ErrorRespFromJson(json);

  final int status;
  final String message;
  final String error;
  @JsonKey(defaultValue: <String>[])
  final List<String> causes;

  Map<String, dynamic> toJson() => _$ErrorRespToJson(this);
}
