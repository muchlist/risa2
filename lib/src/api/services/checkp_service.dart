import 'package:risa2/src/api/json_models/option/location_type.dart';

import '../filter_models/checkp_filter.dart';
import '../http_client.dart';
import '../json_models/request/checkp_edit_req.dart';
import '../json_models/request/checkp_req.dart';
import '../json_models/response/checkp_list_resp.dart';
import '../json_models/response/checkp_resp.dart';
import '../json_models/response/message_resp.dart';
import '../json_parsers/json_parsers.dart';
import '../json_parsers/option_parser.dart';

class CheckpService {
  const CheckpService();

  Future<MessageResponse> createCheckp(CheckpRequest payload) {
    return RequestREST(endpoint: "/check-item", data: payload.toJson())
        .executePost<MessageResponse>(const MessageParser());
  }

  Future<CheckpDetailResponse> editCheckp(
      String id, CheckpEditRequest payload) {
    return RequestREST(endpoint: "/check-item/$id", data: payload.toJson())
        .executePut<CheckpDetailResponse>(const CheckpParser());
  }

  Future<CheckpDetailResponse> getCheckp(String id) {
    return RequestREST(endpoint: "/check-item/$id")
        .executeGet<CheckpDetailResponse>(const CheckpParser());
  }

  Future<MessageResponse> deleteCheckp(String id) {
    return RequestREST(endpoint: "/check-item/$id")
        .executeDelete<MessageResponse>(const MessageParser());
  }

  Future<CheckpListResponse> findCheckp(FilterCheckp f) {
    String query = "";
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
        .executeGet<CheckpListResponse>(const CheckpListParser());
  }

  Future<CheckpDetailResponse> enableCheckp(String id) {
    return RequestREST(endpoint: "/check-item-avail/$id/enable")
        .executeGet<CheckpDetailResponse>(const CheckpParser());
  }

  Future<CheckpDetailResponse> disableCheckp(String id) {
    return RequestREST(endpoint: "/check-item-avail/$id/disable")
        .executeGet<CheckpDetailResponse>(const CheckpParser());
  }

  Future<OptLocationType> getOptCreateCheckp(String branch) {
    return RequestREST(endpoint: "opt-check-item?branch=$branch")
        .executeGet<OptLocationType>(LocationTypeParser());
  }
}
