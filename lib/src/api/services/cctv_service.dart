import 'package:risa2/src/api/json_models/request/cctv_edit_req.dart';
import 'package:risa2/src/api/json_models/request/cctv_req.dart';
import 'package:risa2/src/api/json_models/response/cctv_list_resp.dart';
import 'package:risa2/src/api/json_models/response/message_resp.dart';
import 'package:risa2/src/api/json_parsers/message_parser.dart';

import '../http_client.dart';
import '../json_models/response/cctv_resp.dart';
import '../json_parsers/cctv_parser.dart';

class CctvService {
  const CctvService();

  Future<MessageResponse> createCctv(CctvRequest payload) {
    return RequestREST(endpoint: "/cctv", data: payload.toJson())
        .executePost<MessageResponse>(MessageParser());
  }

  Future<CctvDetailResponse> editCctv(String id, CctvEditRequest payload) {
    return RequestREST(endpoint: "/cctv/$id", data: payload.toJson())
        .executePost<CctvDetailResponse>(CctvParser());
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

  // Future<CctvListResponse> findCctv(FilterImporve f) {
  //   var query = "";
  //   if (f.branch != null) {
  //     query = query + "branch=${f.branch}&";
  //   }
  //   if (f.completeStatus != null) {
  //     query = query + "c_status=${f.completeStatus}&";
  //   }
  //   if (f.start != null) {
  //     query = query + "start=${f.start}&";
  //   }
  //   if (f.end != null) {
  //     query = query + "end=${f.end}&";
  //   }
  //   if (f.limit != null) {
  //     query = query + "limit=${f.limit}";
  //   }

  //   return RequestREST(endpoint: "/cctv?$query")
  //       .executeGet<CctvListResponse>(CctvListParser());
  // }
}
