import 'dart:io';

import 'package:dio/dio.dart';

import '../filter_models/cctv_filter.dart';
import '../http_client.dart';
import '../json_models/option/location_type.dart';
import '../json_models/request/cctv_edit_req.dart';
import '../json_models/request/cctv_req.dart';
import '../json_models/response/cctv_list_resp.dart';
import '../json_models/response/cctv_resp.dart';
import '../json_models/response/message_resp.dart';
import '../json_parsers/json_parsers.dart';

class CctvService {
  const CctvService();

  Future<MessageResponse> createCctv(CctvRequest payload) {
    return RequestREST(endpoint: "/cctv", data: payload.toJson())
        .executePost<MessageResponse>(MessageParser());
  }

  Future<CctvDetailResponse> editCctv(String id, CctvEditRequest payload) {
    return RequestREST(endpoint: "/cctv/$id", data: payload.toJson())
        .executePut<CctvDetailResponse>(CctvParser());
  }

  Future<CctvDetailResponse> getCctv(String id) {
    return RequestREST(endpoint: "/cctv/$id")
        .executeGet<CctvDetailResponse>(CctvParser());
  }

  Future<CctvDetailResponse> enableCctv(String id) {
    return RequestREST(endpoint: "/cctv-avail/$id/enable")
        .executeGet<CctvDetailResponse>(CctvParser());
  }

  Future<CctvDetailResponse> disableCctv(String id) {
    return RequestREST(endpoint: "/cctv-avail/$id/disable")
        .executeGet<CctvDetailResponse>(CctvParser());
  }

  Future<MessageResponse> deleteCctv(String id) {
    return RequestREST(endpoint: "/cctv/$id")
        .executeDelete<MessageResponse>(MessageParser());
  }

  Future<CctvListResponse> findCctv(FilterCctv f) {
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

    return RequestREST(endpoint: "/cctv?$query")
        .executeGet<CctvListResponse>(CctvListParser());
  }

  Future<CctvDetailResponse> uploadImage(String id, File file) async {
    return RequestREST(endpoint: "/cctv-image/$id", data: <String, dynamic>{
      "image": await MultipartFile.fromFile(file.path)
    }).executeUpload(CctvParser());
  }

  Future<OptLocationType> getOptCreateCctv(String branch) {
    return RequestREST(endpoint: "opt-cctv?branch=$branch")
        .executeGet<OptLocationType>(LocationTypeParser());
  }
}
