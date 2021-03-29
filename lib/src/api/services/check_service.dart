import '../filter_models/check_filter.dart';
import '../http_client.dart';
import '../json_models/request/check_edit_req.dart';
import '../json_models/request/check_req.dart';
import '../json_models/request/check_update_req.dart';
import '../json_models/response/check_list_resp.dart';
import '../json_models/response/check_resp.dart';
import '../json_models/response/message_resp.dart';
import '../json_parsers/json_parsers.dart';

class CheckService {
  const CheckService();

  Future<MessageResponse> createCheck(CheckRequest payload) {
    return RequestREST(endpoint: "/check", data: payload.toJson())
        .executePost<MessageResponse>(MessageParser());
  }

  Future<CheckDetailResponse> editCheck(String id, CheckEditRequest payload) {
    return RequestREST(endpoint: "/check/$id", data: payload.toJson())
        .executePut<CheckDetailResponse>(CheckParser());
  }

  Future<CheckDetailResponse> getCheck(String id) {
    return RequestREST(endpoint: "/check/$id")
        .executeGet<CheckDetailResponse>(CheckParser());
  }

  Future<MessageResponse> deleteCheck(String id) {
    return RequestREST(endpoint: "/check/$id")
        .executeDelete<MessageResponse>(MessageParser());
  }

  Future<CheckListResponse> findCheck(FilterCheck f) {
    var query = "";
    if (f.branch != null) {
      query = query + "branch=${f.branch}&";
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
    return RequestREST(endpoint: "/check?$query")
        .executeGet<CheckListResponse>(CheckListParser());
  }

  Future<CheckDetailResponse> updateCheck(CheckUpdateRequest payload) {
    return RequestREST(endpoint: "/check-update", data: payload.toJson())
        .executePost<CheckDetailResponse>(CheckParser());
  }
}
