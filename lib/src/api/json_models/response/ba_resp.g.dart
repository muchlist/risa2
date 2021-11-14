// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ba_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaDetailResponse _$BaDetailResponseFromJson(Map<String, dynamic> json) {
  return BaDetailResponse(
    json['error'] == null
        ? null
        : ErrorResp.fromJson(json['error'] as Map<String, dynamic>),
    json['data'] == null
        ? null
        : BaDetailResponseData.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$BaDetailResponseToJson(BaDetailResponse instance) =>
    <String, dynamic>{
      'error': instance.error?.toJson(),
      'data': instance.data?.toJson(),
    };

BaDetailResponseData _$BaDetailResponseDataFromJson(Map<String, dynamic> json) {
  return BaDetailResponseData(
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
    json['doc_type'] as String,
    (json['descriptions'] as List<dynamic>?)
            ?.map((e) => Description.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    (json['equipments'] as List<dynamic>?)
            ?.map((e) => Equipment.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$BaDetailResponseDataToJson(
        BaDetailResponseData instance) =>
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
      'doc_type': instance.docType,
      'images': instance.images,
      'participants': instance.participants.map((e) => e.toJson()).toList(),
      'approvers': instance.approvers.map((e) => e.toJson()).toList(),
      'descriptions': instance.descriptions.map((e) => e.toJson()).toList(),
      'equipments': instance.equipments.map((e) => e.toJson()).toList(),
    };

Participant _$ParticipantFromJson(Map<String, dynamic> json) {
  return Participant(
    json['id'] as String,
    json['name'] as String,
    json['alias'] as String,
    json['division'] as String,
    json['user_id'] as String,
    json['sign'] as String,
    json['signAt'] as int,
  );
}

Map<String, dynamic> _$ParticipantToJson(Participant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'alias': instance.alias,
      'division': instance.division,
      'user_id': instance.userID,
      'sign': instance.sign,
      'signAt': instance.signAt,
    };

Description _$DescriptionFromJson(Map<String, dynamic> json) {
  return Description(
    json['position'] as int,
    json['description'] as String,
    json['description_type'] as String,
  );
}

Map<String, dynamic> _$DescriptionToJson(Description instance) =>
    <String, dynamic>{
      'position': instance.position,
      'description': instance.description,
      'description_type': instance.descriptionType,
    };

Equipment _$EquipmentFromJson(Map<String, dynamic> json) {
  return Equipment(
    json['id'] as String,
    json['equipment_name'] as String,
    json['attach_to'] as String,
    json['description'] as String,
    json['qty'] as int,
  );
}

Map<String, dynamic> _$EquipmentToJson(Equipment instance) => <String, dynamic>{
      'id': instance.id,
      'equipment_name': instance.equipmentName,
      'attach_to': instance.attachTo,
      'description': instance.description,
      'qty': instance.qty,
    };
