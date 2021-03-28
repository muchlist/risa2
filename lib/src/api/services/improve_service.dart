import 'package:risa2/src/api/json_models/request/improve_edit_req.dart';
import 'package:risa2/src/api/json_models/request/improve_req.dart';
import 'package:risa2/src/api/json_models/response/improve_list_resp.dart';
import 'package:risa2/src/api/json_models/response/message_resp.dart';
import 'package:risa2/src/api/json_parsers/message_parser.dart';

import '../filter_models/improve_filter.dart';

import '../http_client.dart';
import '../json_models/response/improve_resp.dart';
import '../json_parsers/improve_parser.dart';

class ImproveService {
  const ImproveService();

  Future<MessageResponse> createImprove(ImproveRequest payload) {
    return RequestREST(endpoint: "/improve", data: payload.toJson())
        .executePost<MessageResponse>(MessageParser());
  }

  Future<ImproveDetailResponse> changeImprove(ImproveChange payload) {
    return RequestREST(endpoint: "/improve-change", data: payload.toJson())
        .executePost<ImproveDetailResponse>(ImproveParser());
  }

  Future<ImproveDetailResponse> editImprove(
      String id, ImproveEditRequest payload) {
    return RequestREST(endpoint: "/improve/$id", data: payload.toJson())
        .executePost<ImproveDetailResponse>(ImproveParser());
  }

  Future<ImproveDetailResponse> getImprove(String id) {
    return RequestREST(endpoint: "/improve/$id")
        .executeGet<ImproveDetailResponse>(ImproveParser());
  }

  Future<ImproveDetailResponse> enableImprove(String id) {
    return RequestREST(endpoint: "/improve-status/$id/enable")
        .executeGet<ImproveDetailResponse>(ImproveParser());
  }

  Future<ImproveDetailResponse> disableImprove(String id) {
    return RequestREST(endpoint: "/improve-status/$id/disable")
        .executeGet<ImproveDetailResponse>(ImproveParser());
  }

  Future<MessageResponse> deleteImprove(String id) {
    return RequestREST(endpoint: "/improve/$id")
        .executeDelete<MessageResponse>(MessageParser());
  }

  Future<ImproveListResponse> findImprove(FilterImporve f) {
    var query = "";
    if (f.branch != null) {
      query = query + "branch=${f.branch}&";
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
      query = query + "limit=${f.limit}";
    }

    return RequestREST(endpoint: "/improve?$query")
        .executeGet<ImproveListResponse>(ImproveListParser());
  }
}
