import 'dart:io';

import 'package:dio/dio.dart';

import '../filter_models/history_filter.dart';
import '../http_client.dart';
import '../json_models/request/history_edit_req.dart';
import '../json_models/request/history_req.dart';
import '../json_models/response/history_list_resp.dart';
import '../json_models/response/history_resp.dart';
import '../json_models/response/message_resp.dart';
import '../json_parsers/json_parsers.dart';

class HistoryService {
  const HistoryService();

  Future<MessageResponse> createHistory(HistoryRequest payload) {
    return RequestREST(endpoint: "/histories", data: payload.toJson())
        .executePost<MessageResponse>(const MessageParser());
  }

  Future<HistoryListResponse> findHistory(FilterHistory f,
      {String search = ""}) {
    String query = "";
    if (f.branch != null) {
      query = query + "branch=${f.branch}&";
    }
    if (f.category != null) {
      query = query + "category=${f.category}&";
    }
    if (f.completeStatus != null) {
      query = query + "c_status=${f.completeStatus}&";
    }
    if (f.start != null) {
      query = query + "start=${f.start}&";
    }
    if (f.end != null) {
      query = query + "end=${f.end}&";
    }
    if (f.limit != null) {
      query = query + "limit=${f.limit}&";
    }
    if (search != "") {
      query = query + "search=$search&";
    }

    return RequestREST(endpoint: "/histories?$query")
        .executeGet<HistoryListResponse>(const HistoryListParser());
  }

  // {{url}}/api/v1/histories-home?branch=&category=
  Future<HistoryListResponse> findHistoryHome(FilterHistory f) {
    String query = "";
    if (f.branch != null) {
      query = query + "branch=${f.branch}&";
    }
    if (f.category != null) {
      query = query + "category=${f.category}&";
    }

    return RequestREST(endpoint: "/histories-home?$query")
        .executeGet<HistoryListResponse>(const HistoryListParser());
  }

  Future<HistoryListResponse> findHistoryFromParent(String id) {
    return RequestREST(endpoint: "/histories-parent/$id")
        .executeGet<HistoryListResponse>(const HistoryListParser());
  }

  Future<HistoryListResponse> findHistoryFromUser(String id,
      {int? start, int? end, int? limit}) {
    String query = "";
    if (start != null) {
      query = query + "start=$start&";
    }
    if (end != null) {
      query = query + "end=$end&";
    }
    if (limit != null) {
      query = query + "limit=$limit&";
    }

    return RequestREST(endpoint: "/histories-parent/$id?$query")
        .executeGet<HistoryListResponse>(const HistoryListParser());
  }

  Future<HistoryDetailResponse> getHistory(String id) {
    return RequestREST(endpoint: "/histories/$id")
        .executeGet<HistoryDetailResponse>(const HistoryParser());
  }

  Future<HistoryDetailResponse> editHistory(
      String id, HistoryEditRequest payload) {
    return RequestREST(endpoint: "/histories/$id", data: payload.toJson())
        .executePut<HistoryDetailResponse>(const HistoryParser());
  }

  Future<MessageResponse> deleteHistory(String id) {
    return RequestREST(endpoint: "/histories/$id")
        .executeDelete<MessageResponse>(const MessageParser());
  }

  Future<HistoryDetailResponse> uploadImage(String id, File file) async {
    return RequestREST(endpoint: "/history-image/$id", data: <String, dynamic>{
      "image": await MultipartFile.fromFile(file.path)
    }).executeUpload(const HistoryParser());
  }

  Future<MessageResponse> uploadImageForPath(File file) async {
    return RequestREST(endpoint: "/upload-image", data: <String, dynamic>{
      "image": await MultipartFile.fromFile(file.path)
    }).executeUpload<MessageResponse>(const MessageParser());
  }
}
