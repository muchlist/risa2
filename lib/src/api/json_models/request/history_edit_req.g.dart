// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_edit_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryEditRequest _$HistoryEditRequestFromJson(Map<String, dynamic> json) {
  return HistoryEditRequest(
    filterTimestamp: json['filter_timestamp'] as int,
    problem: json['problem'] as String,
    problemResolve: json['problem_resolve'] as String,
    status: json['status'] as String,
    tag:
        (json['tag'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    completeStatus: json['complete_status'] as int,
    dateEnd: json['date_end'] as int,
  );
}

Map<String, dynamic> _$HistoryEditRequestToJson(HistoryEditRequest instance) =>
    <String, dynamic>{
      'filter_timestamp': instance.filterTimestamp,
      'problem': instance.problem,
      'problem_resolve': instance.problemResolve,
      'status': instance.status,
      'tag': instance.tag,
      'complete_status': instance.completeStatus,
      'date_end': instance.dateEnd,
    };
