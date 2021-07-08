import 'package:json_annotation/json_annotation.dart';

import 'error_resp.dart';

part 'pdf_list_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class PdfListResponse {
  final ErrorResp? error;
  @JsonKey(defaultValue: [])
  final List<PdfData> data;

  PdfListResponse(this.error, this.data);

  factory PdfListResponse.fromJson(Map<String, dynamic> json) =>
      _$PdfListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PdfListResponseToJson(this);
}

@JsonSerializable()
class PdfData {
  final String id;
  @JsonKey(name: "created_at")
  final int createdAt;
  @JsonKey(name: "created_by")
  final String createdBy;
  final String branch;
  final String name;
  final String type;
  @JsonKey(name: "file_name")
  final String fileName;

  PdfData(this.id, this.createdAt, this.createdBy, this.branch, this.name,
      this.type, this.fileName);

  factory PdfData.fromJson(Map<String, dynamic> json) =>
      _$PdfDataFromJson(json);

  Map<String, dynamic> toJson() => _$PdfDataToJson(this);
}
