import 'dart:io';

import 'package:dio/dio.dart';

import '../filter_models/computer_filter.dart';
import '../http_client.dart';
import '../json_models/option/location_type.dart';
import '../json_models/request/computer_edit_req.dart';
import '../json_models/request/computer_req.dart';
import '../json_models/response/computer_list_resp.dart';
import '../json_models/response/computer_resp.dart';
import '../json_models/response/message_resp.dart';
import '../json_parsers/json_parsers.dart';

class ComputerService {
  const ComputerService();

  Future<MessageResponse> createComputer(ComputerRequest payload) {
    return RequestREST(endpoint: "/computer", data: payload.toJson())
        .executePost<MessageResponse>(MessageParser());
  }

  Future<ComputerDetailResponse> editComputer(
      String id, ComputerEditRequest payload) {
    return RequestREST(endpoint: "/computer/$id", data: payload.toJson())
        .executePut<ComputerDetailResponse>(ComputerParser());
  }

  Future<ComputerDetailResponse> getComputer(String id) {
    return RequestREST(endpoint: "/computer/$id")
        .executeGet<ComputerDetailResponse>(ComputerParser());
  }

  Future<ComputerDetailResponse> enableComputer(String id) {
    return RequestREST(endpoint: "/computer-avail/$id/enable")
        .executeGet<ComputerDetailResponse>(ComputerParser());
  }

  Future<ComputerDetailResponse> disableComputer(String id) {
    return RequestREST(endpoint: "/computer-avail/$id/disable")
        .executeGet<ComputerDetailResponse>(ComputerParser());
  }

  Future<MessageResponse> deleteComputer(String id) {
    return RequestREST(endpoint: "/computer/$id")
        .executeDelete<MessageResponse>(MessageParser());
  }

  Future<ComputerListResponse> findComputer(FilterComputer f) {
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
    if (f.seat != null) {
      query = query + "seat=${f.seat}";
    }

    return RequestREST(endpoint: "/computer?$query")
        .executeGet<ComputerListResponse>(ComputerListParser());
  }

  Future<ComputerDetailResponse> uploadImage(String id, File file) async {
    return RequestREST(endpoint: "/computer-image/$id", data: <String, dynamic>{
      "image": await MultipartFile.fromFile(file.path)
    }).executeUpload(ComputerParser());
  }

  Future<OptLocationType> getOptCreateComputer(String branch) {
    return RequestREST(endpoint: "opt-computer?branch=$branch")
        .executeGet<OptLocationType>(LocationTypeParser());
  }
}
