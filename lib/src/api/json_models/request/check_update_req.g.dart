// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_update_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckUpdateRequest _$CheckUpdateRequestFromJson(Map<String, dynamic> json) {
  return CheckUpdateRequest(
    parentID: json['parent_id'] as String,
    childID: json['child_id'] as String,
    checkedNote: json['checked_note'] as String,
    isChecked: json['is_checked'] as bool,
    haveProblem: json['have_problem'] as bool,
    completeStatus: json['complete_status'] as int,
    tagSelected: json['tag_selected'] as String,
    tagExtraSelected: json['tag_extra_selected'] as String,
  );
}

Map<String, dynamic> _$CheckUpdateRequestToJson(CheckUpdateRequest instance) =>
    <String, dynamic>{
      'parent_id': instance.parentID,
      'child_id': instance.childID,
      'checked_note': instance.checkedNote,
      'is_checked': instance.isChecked,
      'have_problem': instance.haveProblem,
      'complete_status': instance.completeStatus,
      'tag_selected': instance.tagSelected,
      'tag_extra_selected': instance.tagExtraSelected,
    };
