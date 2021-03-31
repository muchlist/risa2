import '../filter_models/checkp_filter.dart';
import '../http_client.dart';
import '../json_models/request/checkp_edit_req.dart';
import '../json_models/request/checkp_req.dart';
import '../json_models/response/checkp_list_resp.dart';
import '../json_models/response/checkp_resp.dart';
import '../json_models/response/message_resp.dart';
import '../json_parsers/json_parsers.dart';

class CheckpService {
  const CheckpService();

  Future<MessageResponse> createCheckp(CheckpRequest payload) {
    return RequestREST(endpoint: "/check-item", data: payload.toJson())
        .executePost<MessageResponse>(MessageParser());
  }

  Future<CheckpDetailResponse> editCheckp(
      String id, CheckpEditRequest payload) {
    return RequestREST(endpoint: "/check-item/$id", data: payload.toJson())
        .executePut<CheckpDetailResponse>(CheckpParser());
  }

  Future<CheckpDetailResponse> getCheckp(String id) {
    return RequestREST(endpoint: "/check-item/$id")
        .executeGet<CheckpDetailResponse>(CheckpParser());
  }

  Future<MessageResponse> deleteCheckp(String id) {
    return RequestREST(endpoint: "/checkp/$id")
        .executeDelete<MessageResponse>(MessageParser());
  }

  Future<CheckpListResponse> findCheckp(FilterCheckp f) {
    var query = "";
    if (f.branch != null) {
      query = query + "branch=${f.branch}&";
    }
    if (f.name != null) {
      query = query + "name=${f.name}&";
    }
    if (f.problem != null) {
      query = query + "problem=${f.problem}&";
    }
    if (f.disable != null) {
      query = query + "disable=${f.disable}&";
    }
    return RequestREST(endpoint: "/check-item?$query")
        .executeGet<CheckpListResponse>(CheckpListParser());
  }

  Future<CheckpDetailResponse> enableCheckp(String id) {
    return RequestREST(endpoint: "/check-item-avail/$id/enable")
        .executeGet<CheckpDetailResponse>(CheckpParser());
  }

  Future<CheckpDetailResponse> disableCheckp(String id) {
    return RequestREST(endpoint: "/check-item-avail/$id/disable")
        .executeGet<CheckpDetailResponse>(CheckpParser());
  }
}
