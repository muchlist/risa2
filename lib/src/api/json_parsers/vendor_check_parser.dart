import '../json_models/response/error_resp.dart';
import '../json_models/response/vendor_check_list_resp.dart';
import '../json_models/response/vendor_check_resp.dart';

import 'json_parsers.dart';

class VendorCheckParser extends JsonParser<VendorCheckDetailResponse>
    with ObjectDecoder<VendorCheckDetailResponse> {
  const VendorCheckParser();

  @override
  Future<VendorCheckDetailResponse> parseFromJson(String json) async {
    try {
      final Map<String, dynamic> decoded = decodeJsonObject(json);
      return VendorCheckDetailResponse.fromJson(decoded);
    } catch (e) {
      return VendorCheckDetailResponse(
          ErrorResp(0, e.toString(), "", <String>[]), null);
    }
  }
}

class VendorCheckListParser extends JsonParser<VendorCheckListResponse>
    with ObjectDecoder<VendorCheckListResponse> {
  const VendorCheckListParser();

  @override
  Future<VendorCheckListResponse> parseFromJson(String json) async {
    try {
      final Map<String, dynamic> decoded = decodeJsonObject(json);
      return VendorCheckListResponse.fromJson(decoded);
    } catch (e) {
      return VendorCheckListResponse(ErrorResp(0, e.toString(), "", <String>[]),
          <VendorCheckMinResponse>[]);
    }
  }
}
