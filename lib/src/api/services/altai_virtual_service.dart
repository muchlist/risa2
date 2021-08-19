import '../filter_models/check_filter.dart';
import '../http_client.dart';
import '../json_models/request/altai_virtual_req.dart';
import '../json_models/response/altai_virtual_list_resp.dart';
import '../json_models/response/altai_virtual_resp.dart';
import '../json_models/response/message_resp.dart';
import '../json_parsers/altai_virtual_parser.dart';
import '../json_parsers/json_parsers.dart';

class AltaiVirtualService {
  const AltaiVirtualService();

  Future<MessageResponse> createAltaiVirtual() {
    return RequestREST(endpoint: "/altai-check?", data: <String, dynamic>{})
        .executePost<MessageResponse>(const MessageParser());
  }

  Future<AltaiVirtualDetailResponse> getAltaiVirtual(String id) {
    return RequestREST(endpoint: "/altai-check/$id")
        .executeGet<AltaiVirtualDetailResponse>(const AltaiVirtualParser());
  }

  // {{url}}/api/v1/altai-check-finish/60f7bd8d52ffaa4bbb3c3997
  Future<AltaiVirtualDetailResponse> finishAltaiVirtual(String id) {
    return RequestREST(endpoint: "/altai-check-finish/$id")
        .executeGet<AltaiVirtualDetailResponse>(const AltaiVirtualParser());
  }

  Future<MessageResponse> deleteAltaiVirtual(String id) {
    return RequestREST(endpoint: "/altai-check/$id")
        .executeDelete<MessageResponse>(const MessageParser());
  }

  Future<AltaiVirtualListResponse> findAltaiVirtual(FilterCheck f) {
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
    return RequestREST(endpoint: "/altai-check?$query")
        .executeGet<AltaiVirtualListResponse>(const AltaiVirtualListParser());
  }

  Future<AltaiVirtualDetailResponse> updateAltaiVirtual(
      AltaiVirtualUpdateRequest payload) {
    return RequestREST(endpoint: "/altai-check-update", data: payload.toJson())
        .executePost<AltaiVirtualDetailResponse>(const AltaiVirtualParser());
  }
}
