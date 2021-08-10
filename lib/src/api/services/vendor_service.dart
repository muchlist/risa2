import '../filter_models/check_filter.dart';
import '../http_client.dart';
import '../json_models/request/vendor_req.dart';
import '../json_models/response/message_resp.dart';
import '../json_models/response/vendor_check_list_resp.dart';
import '../json_models/response/vendor_check_resp.dart';
import '../json_parsers/json_parsers.dart';
import '../json_parsers/vendor_check_parser.dart';

class VendorCheckService {
  const VendorCheckService();

  Future<MessageResponse> createVendorCheck(bool isVirtual) {
    String isVirtualString = "";
    if (isVirtual) {
      isVirtualString = "yes";
    }
    return RequestREST(
            endpoint: "/vendor-check?virtual=$isVirtualString",
            data: <String, dynamic>{})
        .executePost<MessageResponse>(const MessageParser());
  }

  Future<VendorCheckDetailResponse> getVendorCheck(String id) {
    return RequestREST(endpoint: "/vendor-check/$id")
        .executeGet<VendorCheckDetailResponse>(const VendorCheckParser());
  }

  // {{url}}/api/v1/vendor-check-finish/60f7bd8d52ffaa4bbb3c3997
  Future<VendorCheckDetailResponse> finishVendorCheck(String id) {
    return RequestREST(endpoint: "/vendor-check-finish/$id")
        .executeGet<VendorCheckDetailResponse>(const VendorCheckParser());
  }

  Future<MessageResponse> deleteVendorCheck(String id) {
    return RequestREST(endpoint: "/vendor-check/$id")
        .executeDelete<MessageResponse>(const MessageParser());
  }

  Future<VendorCheckListResponse> findVendorCheck(FilterCheck f) {
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
    return RequestREST(endpoint: "/vendor-check?$query")
        .executeGet<VendorCheckListResponse>(const VendorCheckListParser());
  }

  Future<VendorCheckDetailResponse> updateVendorCheck(
      VendorUpdateRequest payload) {
    return RequestREST(endpoint: "/vendor-check-update", data: payload.toJson())
        .executePost<VendorCheckDetailResponse>(const VendorCheckParser());
  }

  Future<MessageResponse> bulkUpdateVendorCheck(
      BulkVendorUpdateRequest payload) {
    return RequestREST(endpoint: "/bulk-vendor-update", data: payload.toJson())
        .executePost<MessageResponse>(const MessageParser());
  }
}
