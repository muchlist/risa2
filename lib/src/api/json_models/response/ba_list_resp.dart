// {
//     "data": [
//         {
//             "id": "618f534b8cff5f1a62d4a866",
//             "created_at": 1636782923,
//             "created_by": "muchlis",
//             "created_by_id": "1191122712",
//             "updated_at": 1636783061,
//             "updated_by": "muchlis",
//             "updated_by_id": "1191122712",
//             "branch": "BANJARMASIN",
//             "number": "BN001",
//             "title": "BERITA ACARA PEMERIKSAAN KERUSAKAN CCTV ",
//             "date": 1636782923,
//             "participants": [
//                 {
//                     "id": "1191122712",
//                     "name": "muchlis",
//                     "position": "",
//                     "division": "",
//                     "user_id": "1191122712",
//                     "sign": "",
//                     "sign_at": 0,
//                     "alias": "pihak pertama"
//                 }
//             ],
//             "approvers": [
//                 {
//                     "id": "VENDOR",
//                     "name": "VENDOR",
//                     "position": "",
//                     "division": "",
//                     "user_id": "VENDOR",
//                     "sign": "",
//                     "sign_at": 0,
//                     "alias": "Mengetahui"
//                 }
//             ],
//             "complete_status": 0,
//             "location": "BANJARMASIN",
//             "images": [],
//             "doc_type": ""
//         }
//     ],
//     "error": null
// }

import 'package:json_annotation/json_annotation.dart';

import 'ba_resp.dart';
import 'error_resp.dart';

part 'ba_list_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class BaListResponse {
  BaListResponse(this.error, this.data);

  factory BaListResponse.fromJson(Map<String, dynamic> json) =>
      _$BaListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BaListResponseToJson(this);

  final ErrorResp? error;
  @JsonKey(defaultValue: <BaMinResponse>[])
  final List<BaMinResponse> data;
}

@JsonSerializable(explicitToJson: true)
class BaMinResponse {
  BaMinResponse(
    this.id,
    this.createdAt,
    this.createdBy,
    this.createdById,
    this.updatedAt,
    this.updatedBy,
    this.updatedById,
    this.branch,
    this.number,
    this.title,
    this.date,
    this.participants,
    this.approvers,
    this.completeStatus,
    this.location,
    this.images,
    this.docType,
  );

  factory BaMinResponse.fromJson(Map<String, dynamic> json) =>
      _$BaMinResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BaMinResponseToJson(this);

  final String id;
  @JsonKey(name: "created_at")
  final int createdAt;
  @JsonKey(name: "created_by")
  final String createdBy;
  @JsonKey(name: "created_by_id")
  final String createdById;
  @JsonKey(name: "updated_at")
  final int updatedAt;
  @JsonKey(name: "updated_by")
  final String updatedBy;
  @JsonKey(name: "updated_by_id")
  final String updatedById;
  final String branch;
  final String number;
  final String title;
  final int date;
  @JsonKey(name: "complete_status")
  final int completeStatus;
  final String location;
  @JsonKey(name: "doc_type")
  final String docType;
  @JsonKey(defaultValue: <String>[])
  final List<String> images;
  @JsonKey(defaultValue: <Participant>[])
  final List<Participant> participants;
  @JsonKey(defaultValue: <Participant>[])
  final List<Participant> approvers;
}
