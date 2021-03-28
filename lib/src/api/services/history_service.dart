import 'package:risa2/src/api/filter_models/history_filter.dart';
import 'package:risa2/src/api/json_models/request/history_edit_req.dart';
import 'package:risa2/src/api/json_models/request/history_req.dart';
import 'package:risa2/src/api/json_models/response/history_list_resp.dart';
import 'package:risa2/src/api/json_models/response/message_resp.dart';
import 'package:risa2/src/api/json_parsers/message_parser.dart';

import '../http_client.dart';
import '../json_models/response/history_resp.dart';
import '../json_parsers/history_parser.dart';

class HistoryService {
  const HistoryService();

  Future<MessageResponse> createHistory(HistoryRequest payload) {
    return RequestREST(endpoint: "/histories", data: payload.toJson())
        .executePost<MessageResponse>(MessageParser());
  }

  Future<HistoryListResponse> findHistory(FilterHistory f) {
    var query = "";
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

    return RequestREST(endpoint: "/histories?$query")
        .executeGet<HistoryListResponse>(HistoryListParser());
  }

  Future<HistoryListResponse> findHistoryFromParent(String id) {
    return RequestREST(endpoint: "/histories-parent/$id")
        .executeGet<HistoryListResponse>(HistoryListParser());
  }

  Future<HistoryListResponse> findHistoryFromUser(String id,
      {int? start, int? end, int? limit}) {
    var query = "";
    if (start != null) {
      query = query + "start=${start}&";
    }
    if (end != null) {
      query = query + "end=${end}&";
    }
    if (limit != null) {
      query = query + "limit=${limit}&";
    }

    return RequestREST(endpoint: "/histories-parent/$id?$query")
        .executeGet<HistoryListResponse>(HistoryListParser());
  }

  Future<HistoryDetailResponse> getHistory(String id) {
    return RequestREST(endpoint: "/histories/$id")
        .executeGet<HistoryDetailResponse>(HistoryParser());
  }

  Future<HistoryDetailResponse> editHistory(
      String id, HistoryEditRequest payload) {
    return RequestREST(endpoint: "/histories/$id", data: payload.toJson())
        .executePut<HistoryDetailResponse>(HistoryParser());
  }

  Future<MessageResponse> deleteHistory(String id) {
    return RequestREST(endpoint: "/histories/$id")
        .executeDelete<MessageResponse>(MessageParser());
  }
}
