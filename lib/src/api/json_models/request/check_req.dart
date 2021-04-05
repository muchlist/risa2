import 'package:json_annotation/json_annotation.dart';

part 'check_req.g.dart';

@JsonSerializable()
class CheckRequest {
  final int shift;

  CheckRequest({required this.shift});

  factory CheckRequest.fromJson(Map<String, dynamic> json) =>
      _$CheckRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CheckRequestToJson(this);
}
