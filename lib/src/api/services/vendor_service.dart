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
    var isVirtualString = "";
    if (isVirtual) {
      isVirtualString = "yes";
    }
    return RequestREST(
        endpoint: "/vendor-check?virtual=$isVirtualString",
        data: {}).executePost<MessageResponse>(MessageParser());
  }

  Future<VendorCheckDetailResponse> getVendorCheck(String id) {
    return RequestREST(endpoint: "/vendor-check/$id")
        .executeGet<VendorCheckDetailResponse>(VendorCheckParser());
  }

  Future<MessageResponse> deleteVendorCheck(String id) {
    return RequestREST(endpoint: "/vendor-check/$id")
        .executeDelete<MessageResponse>(MessageParser());
  }

  Future<VendorCheckListResponse> findVendorCheck(FilterCheck f) {
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
    return RequestREST(endpoint: "/vendor-check?$query")
        .executeGet<VendorCheckListResponse>(VendorCheckListParser());
  }

  Future<VendorCheckDetailResponse> updateVendorCheck(
      VendorUpdateRequest payload) {
    return RequestREST(endpoint: "/vendor-check-update", data: payload.toJson())
        .executePost<VendorCheckDetailResponse>(VendorCheckParser());
  }

  Future<MessageResponse> bulkUpdateVendorCheck(
      BulkVendorUpdateRequest payload) {
    return RequestREST(endpoint: "/bulk-vendor-update", data: payload.toJson())
        .executePost<MessageResponse>(MessageParser());
  }
}
