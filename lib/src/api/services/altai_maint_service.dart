import '../filter_models/check_filter.dart';
import '../http_client.dart';
import '../json_models/request/altai_maintenance_req.dart';
import '../json_models/response/altai_maintenance_resp.dart';
import '../json_models/response/main_maintenance_list_resp.dart';
import '../json_models/response/message_resp.dart';
import '../json_parsers/json_parsers.dart';

class AltaiMaintService {
  const AltaiMaintService();

  Future<MessageResponse> createAltaiMaintenance(bool isQuartal, String name) {
    return RequestREST(
        endpoint: isQuartal ? "/altai-phy-check-quarter" : "/altai-phy-check",
        data: <String, dynamic>{
          "name": name
        }).executePost<MessageResponse>(const MessageParser());
  }

  Future<AltaiMaintDetailResponse> getAltaiMaintenance(String id) {
    return RequestREST(endpoint: "/altai-phy-check/$id")
        .executeGet<AltaiMaintDetailResponse>(const AltaiMaintParser());
  }

  // {{url}}/api/v1/phy-check-finish/60f7bd8d52ffaa4bbb3c3997
  Future<AltaiMaintDetailResponse> finishAltaiMaintenance(String id) {
    return RequestREST(endpoint: "/altai-phy-check-finish/$id")
        .executeGet<AltaiMaintDetailResponse>(const AltaiMaintParser());
  }

  Future<MessageResponse> deleteAltaiMaintenance(String id) {
    return RequestREST(endpoint: "/altai-phy-check/$id")
        .executeDelete<MessageResponse>(const MessageParser());
  }

  Future<MainMaintenanceListResponse> findAltaiMaintenance(FilterCheck f) {
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
    return RequestREST(endpoint: "/altai-phy-check?$query")
        .executeGet<MainMaintenanceListResponse>(const AltaiMaintListParser());
  }

  Future<AltaiMaintDetailResponse> updateAltaiMaint(
      AltaiMaintUpdateRequest payload) {
    return RequestREST(
            endpoint: "/altai-phy-check-update", data: payload.toJson())
        .executePost<AltaiMaintDetailResponse>(const AltaiMaintParser());
  }
}
