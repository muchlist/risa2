import 'package:json_annotation/json_annotation.dart';
import 'error_resp.dart';

part 'message_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class MessageResponse {
  final ErrorResp? error;
  final String? data;

  MessageResponse(this.error, this.data);

  factory MessageResponse.fromJson(Map<String, dynamic> json) =>
      _$MessageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MessageResponseToJson(this);
}
