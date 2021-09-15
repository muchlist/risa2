import '../filter_models/check_filter.dart';
import '../http_client.dart';
import '../json_models/request/config_check_req.dart';
import '../json_models/response/config_check_list_resp.dart';
import '../json_models/response/config_check_resp.dart';
import '../json_models/response/message_resp.dart';
import '../json_parsers/json_parsers.dart';

class ConfigCheckService {
  const ConfigCheckService();

  Future<MessageResponse> createConfigCheck() {
    return RequestREST(endpoint: "/config-check?", data: <String, dynamic>{})
        .executePost<MessageResponse>(const MessageParser());
  }

  Future<ConfigCheckDetailResponse> getConfigCheck(String id) {
    return RequestREST(endpoint: "/config-check/$id")
        .executeGet<ConfigCheckDetailResponse>(const ConfigCheckParser());
  }

  // {{url}}/api/v1/altai-check-finish/60f7bd8d52ffaa4bbb3c3997
  Future<ConfigCheckDetailResponse> finishConfigCheck(String id) {
    return RequestREST(endpoint: "/config-check-finish/$id")
        .executeGet<ConfigCheckDetailResponse>(const ConfigCheckParser());
  }

  Future<MessageResponse> deleteConfigCheck(String id) {
    return RequestREST(endpoint: "/config-check/$id")
        .executeDelete<MessageResponse>(const MessageParser());
  }

  Future<ConfigCheckListResponse> findConfigCheck(FilterCheck f) {
    String query = "";
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
    return RequestREST(endpoint: "/config-check?$query")
        .executeGet<ConfigCheckListResponse>(const ConfigCheckListParser());
  }

  Future<ConfigCheckDetailResponse> updateConfigCheck(
      ConfigCheckUpdateRequest payload) {
    return RequestREST(endpoint: "/config-check-update", data: payload.toJson())
        .executePost<ConfigCheckDetailResponse>(const ConfigCheckParser());
  }
}
