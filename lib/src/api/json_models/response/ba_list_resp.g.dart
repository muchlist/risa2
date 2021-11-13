// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ba_list_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaListResponse _$BaListResponseFromJson(Map<String, dynamic> json) {
  return BaListResponse(
    json['error'] == null
        ? null
        : ErrorResp.fromJson(json['error'] as Map<String, dynamic>),
    (json['data'] as List<dynamic>?)
            ?.map((e) => BaMinResponse.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$BaListResponseToJson(BaListResponse instance) =>
    <String, dynamic>{
      'error': instance.error?.toJson(),
      'data': instance.data.map((e) => e.toJson()).toList(),
    };

BaMinResponse _$BaMinResponseFromJson(Map<String, dynamic> json) {
  return BaMinResponse(
    json['id'] as String,
    json['created_at'] as int,
    json['created_by'] as String,
    json['created_by_id'] as String,
    json['updated_at'] as int,
    json['updated_by'] as String,
    json['updated_by_id'] as String,
    json['branch'] as String,
    json['number'] as String,
    json['title'] as String,
    json['date'] as int,
    (json['participants'] as List<dynamic>?)
            ?.map((e) => Participant.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    (json['approvers'] as List<dynamic>?)
            ?.map((e) => Participant.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    json['complete_status'] as int,
    json['location'] as String,
    (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    json['docType'] as String,
  );
}

Map<String, dynamic> _$BaMinResponseToJson(BaMinResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'created_by': instance.createdBy,
      'created_by_id': instance.createdById,
      'updated_at': instance.updatedAt,
      'updated_by': instance.updatedBy,
      'updated_by_id': instance.updatedById,
      'branch': instance.branch,
      'number': instance.number,
      'title': instance.title,
      'date': instance.date,
      'complete_status': instance.completeStatus,
      'location': instance.location,
      'docType': instance.docType,
      'images': instance.images,
      'participants': instance.participants.map((e) => e.toJson()).toList(),
      'approvers': instance.approvers.map((e) => e.toJson()).toList(),
    };
