import 'package:json_annotation/json_annotation.dart';
import 'error_resp.dart';

part 'message_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class MessageResponse {
  MessageResponse(this.error, this.data);

  factory MessageResponse.fromJson(Map<String, dynamic> json) =>
      _$MessageResponseFromJson(json);

  final ErrorResp? error;
  final String? data;

  Map<String, dynamic> toJson() => _$MessageResponseToJson(this);
}
