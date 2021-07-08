// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pdf_list_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PdfListResponse _$PdfListResponseFromJson(Map<String, dynamic> json) {
  return PdfListResponse(
    json['error'] == null
        ? null
        : ErrorResp.fromJson(json['error'] as Map<String, dynamic>),
    (json['data'] as List<dynamic>?)
            ?.map((e) => PdfData.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$PdfListResponseToJson(PdfListResponse instance) =>
    <String, dynamic>{
      'error': instance.error?.toJson(),
      'data': instance.data.map((e) => e.toJson()).toList(),
    };

PdfData _$PdfDataFromJson(Map<String, dynamic> json) {
  return PdfData(
    json['id'] as String,
    json['created_at'] as int,
    json['created_by'] as String,
    json['branch'] as String,
    json['name'] as String,
    json['type'] as String,
    json['file_name'] as String,
  );
}

Map<String, dynamic> _$PdfDataToJson(PdfData instance) => <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'created_by': instance.createdBy,
      'branch': instance.branch,
      'name': instance.name,
      'type': instance.type,
      'file_name': instance.fileName,
    };
