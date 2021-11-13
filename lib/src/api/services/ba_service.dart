import 'dart:io';

import 'package:dio/dio.dart';

import '../filter_models/ba_filter.dart';
import '../http_client.dart';
import '../json_models/request/ba_add_participant_req.dart';
import '../json_models/request/ba_edit_req.dart';
import '../json_models/request/ba_req.dart';
import '../json_models/response/ba_list_resp.dart';
import '../json_models/response/ba_resp.dart';
import '../json_models/response/message_resp.dart';
import '../json_parsers/json_parsers.dart';

class BaService {
  const BaService();

  Future<MessageResponse> createBaTempOne(BaRequest payload) {
    return RequestREST(endpoint: "/pr-template-one", data: payload.toJson())
        .executePost<MessageResponse>(const MessageParser());
  }

  Future<BaDetailResponse> editBa(String id, BaEditRequest payload) {
    return RequestREST(endpoint: "/pending-report/$id", data: payload.toJson())
        .executePut<BaDetailResponse>(const BaParser());
  }

  Future<BaDetailResponse> getBa(String id) {
    return RequestREST(endpoint: "/pending-report/$id")
        .executeGet<BaDetailResponse>(const BaParser());
  }

  Future<BaListResponse> findBa(FilterBa f) {
    String query = "";
    if (f.branch != null) {
      query = query + "branch=${f.branch}&";
    }
    if (f.title != null) {
      query = query + "title=${f.branch}&";
    }
    if (f.complete != null) {
      query = query + "complete=${f.complete}&";
    }
    if (f.limit != null) {
      query = query + "limit=${f.limit}";
    }

    return RequestREST(endpoint: "/pending-report?$query")
        .executeGet<BaListResponse>(const BaListParser());
  }

  Future<BaDetailResponse> addParticipant(
      String id, BaAddParticipantRequest payload) {
    return RequestREST(
            endpoint: "/add-party-pending-report/$id", data: payload.toJson())
        .executePost<BaDetailResponse>(const BaParser());
  }

  Future<BaDetailResponse> addApprover(
      String id, BaAddParticipantRequest payload) {
    return RequestREST(
            endpoint: "/add-approver-pending-report/$id",
            data: payload.toJson())
        .executePost<BaDetailResponse>(const BaParser());
  }

  Future<BaDetailResponse> removeParticipant(String id, String userID) {
    return RequestREST(endpoint: "/remove-party-pending-report/$id/$userID")
        .executePost<BaDetailResponse>(const BaParser());
  }

  Future<BaDetailResponse> removeApprover(String id, String userID) {
    return RequestREST(endpoint: "/remove-approver-pending-report/$id/$userID")
        .executePost<BaDetailResponse>(const BaParser());
  }

  Future<BaDetailResponse> toSignMode(String id) {
    return RequestREST(endpoint: "/send-sign/$id")
        .executePost<BaDetailResponse>(const BaParser());
  }

  Future<BaDetailResponse> toDraftMode(String id) {
    return RequestREST(endpoint: "/send-draft/$id")
        .executePost<BaDetailResponse>(const BaParser());
  }

  Future<BaDetailResponse> uploadImage(String id, File file) async {
    return RequestREST(
        endpoint: "/pending-report-image/$id",
        data: <String, dynamic>{
          "image": await MultipartFile.fromFile(file.path)
        }).executeUpload(const BaParser());
  }

  Future<BaDetailResponse> deleteImage(
      String id, String imageNameWithExt) async {
    return RequestREST(
            endpoint: "/delete-pending-report-image/$id/$imageNameWithExt")
        .executePost<BaDetailResponse>(const BaParser());
  }

  Future<BaDetailResponse> sign(String id, File file) async {
    return RequestREST(
        endpoint: "/sign-pending-report-image/$id",
        data: <String, dynamic>{
          "image": await MultipartFile.fromFile(file.path)
        }).executeUpload(const BaParser());
  }
}
