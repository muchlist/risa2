import 'dart:io';

import 'package:dio/dio.dart';

import '../filter_models/other_filter.dart';
import '../http_client.dart';
import '../json_models/option/location_division.dart';
import '../json_models/request/other_edit_req.dart';
import '../json_models/request/other_req.dart';
import '../json_models/response/message_resp.dart';
import '../json_models/response/other_list_resp.dart';
import '../json_models/response/other_resp.dart';
import '../json_parsers/json_parsers.dart';

class OtherService {
  const OtherService();

  Future<MessageResponse> createOther(OtherRequest payload) {
    return RequestREST(endpoint: "/other", data: payload.toJson())
        .executePost<MessageResponse>(MessageParser());
  }

  Future<OtherDetailResponse> editOther(String id, OtherEditRequest payload) {
    return RequestREST(endpoint: "/other/$id", data: payload.toJson())
        .executePut<OtherDetailResponse>(OtherParser());
  }

  Future<OtherDetailResponse> getOther(String id) {
    return RequestREST(endpoint: "/other/$id")
        .executeGet<OtherDetailResponse>(OtherParser());
  }

  Future<OtherDetailResponse> enableOther(String id, String subCategory) {
    return RequestREST(endpoint: "/other-avail/$subCategory/$id/enable")
        .executeGet<OtherDetailResponse>(OtherParser());
  }

  Future<OtherDetailResponse> disableOther(String id, String subCategory) {
    return RequestREST(endpoint: "/other-avail/$subCategory/$id/disable")
        .executeGet<OtherDetailResponse>(OtherParser());
  }

  Future<MessageResponse> deleteOther(String id, String subCategory) {
    return RequestREST(endpoint: "/other/$subCategory/$id")
        .executeDelete<MessageResponse>(MessageParser());
  }

  Future<OtherListResponse> findOther(FilterOther f, String subCategory) {
    var query = "";
    if (f.branch != null) {
      query = query + "branch=${f.branch}&";
    }
    if (f.ip != null) {
      query = query + "ip=${f.ip}&";
    }
    if (f.name != null) {
      query = query + "name=${f.name}&";
    }
    if (f.location != null) {
      query = query + "location=${f.location}&";
    }
    if (f.disable != null) {
      query = query + "disable=${f.disable}";
    }
    if (f.division != null) {
      query = query + "division=${f.division}";
    }

    return RequestREST(endpoint: "/others/$subCategory?$query")
        .executeGet<OtherListResponse>(OtherListParser());
  }

  Future<OtherDetailResponse> uploadImage(String id, File file) async {
    return RequestREST(endpoint: "/other-image/$id", data: <String, dynamic>{
      "image": await MultipartFile.fromFile(file.path)
    }).executeUpload(OtherParser());
  }

  Future<OptLocationDivison> getOptCreateOther(String branch) {
    return RequestREST(endpoint: "opt-other?branch=$branch")
        .executeGet<OptLocationDivison>(LocationDivisionParser());
  }
}
