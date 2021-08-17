import '../filter_models/check_filter.dart';
import '../http_client.dart';
import '../json_models/request/cctv_maintenance_req.dart';
import '../json_models/response/cctv_maintenance_resp.dart';
import '../json_models/response/main_maintenance_list_resp.dart';
import '../json_models/response/message_resp.dart';
import '../json_parsers/json_parsers.dart';

class CctvMaintService {
  const CctvMaintService();

  Future<MessageResponse> createCctvMaintenance(bool isQuartal, String name) {
    return RequestREST(
            endpoint: isQuartal ? "/phy-check" : "/phy-check-quarter",
            data: <String, dynamic>{name: name})
        .executePost<MessageResponse>(const MessageParser());
  }

  Future<CCTVMaintDetailResponse> getCctvMaintenance(String id) {
    return RequestREST(endpoint: "/phy-check/$id")
        .executeGet<CCTVMaintDetailResponse>(const CCTVMaintParser());
  }

  // {{url}}/api/v1/phy-check-finish/60f7bd8d52ffaa4bbb3c3997
  Future<CCTVMaintDetailResponse> finishCctvMaintenance(String id) {
    return RequestREST(endpoint: "/phy-check-finish/$id")
        .executeGet<CCTVMaintDetailResponse>(const CCTVMaintParser());
  }

  Future<MessageResponse> deleteCctvMaintenance(String id) {
    return RequestREST(endpoint: "/phy-check/$id")
        .executeDelete<MessageResponse>(const MessageParser());
  }

  Future<MainMaintenanceListResponse> findCctvMaintenance(FilterCheck f) {
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
    return RequestREST(endpoint: "/phy-check?$query")
        .executeGet<MainMaintenanceListResponse>(const CCTVMaintListParser());
  }

  Future<CCTVMaintDetailResponse> updateCctvMaint(
      CCTVMaintUpdateRequest payload) {
    return RequestREST(endpoint: "/phy-check-update", data: payload.toJson())
        .executePost<CCTVMaintDetailResponse>(const CCTVMaintParser());
  }

  Future<MessageResponse> bulkUpdateVendorCheck(
      BulkCCTVMaintUpdateRequest payload) {
    return RequestREST(endpoint: "/bulk-phy-update", data: payload.toJson())
        .executePost<MessageResponse>(const MessageParser());
  }
}
