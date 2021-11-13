import 'package:json_annotation/json_annotation.dart';

part 'ba_add_participant_req.g.dart';

@JsonSerializable(explicitToJson: true)
class BaAddParticipantRequest {
  BaAddParticipantRequest({
    required this.userId,
    required this.alias,
  });

  factory BaAddParticipantRequest.fromJson(Map<String, dynamic> json) =>
      _$BaAddParticipantRequestFromJson(json);
  Map<String, dynamic> toJson() => _$BaAddParticipantRequestToJson(this);

  @JsonKey(name: "user_id")
  final String userId;
  final String alias;
}
