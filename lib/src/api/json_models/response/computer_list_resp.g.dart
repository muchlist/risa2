// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'computer_list_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComputerListResponse _$ComputerListResponseFromJson(Map<String, dynamic> json) {
  return ComputerListResponse(
    json['error'] == null
        ? null
        : ErrorResp.fromJson(json['error'] as Map<String, dynamic>),
    ComputerListData.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ComputerListResponseToJson(
        ComputerListResponse instance) =>
    <String, dynamic>{
      'error': instance.error?.toJson(),
      'data': instance.data.toJson(),
    };

ComputerListData _$ComputerListDataFromJson(Map<String, dynamic> json) {
  return ComputerListData(
    (json['computer_list'] as List<dynamic>?)
            ?.map(
                (e) => ComputerMinResponse.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    (json['extra_list'] as List<dynamic>?)
            ?.map((e) => GeneralMinResponse.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$ComputerListDataToJson(ComputerListData instance) =>
    <String, dynamic>{
      'computer_list': instance.computerList.map((e) => e.toJson()).toList(),
      'extra_list': instance.extraList.map((e) => e.toJson()).toList(),
    };

ComputerMinResponse _$ComputerMinResponseFromJson(Map<String, dynamic> json) {
  return ComputerMinResponse(
    json['id'] as String,
    json['branch'] as String,
    json['disable'] as bool,
    json['name'] as String,
    json['division'] as String,
    json['seat_management'] as bool,
    json['ip'] as String,
    json['location'] as String,
    (json['tag'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
  );
}

Map<String, dynamic> _$ComputerMinResponseToJson(
        ComputerMinResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'branch': instance.branch,
      'disable': instance.disable,
      'name': instance.name,
      'division': instance.division,
      'seat_management': instance.seatManagement,
      'ip': instance.ip,
      'location': instance.location,
      'tag': instance.tag,
    };
