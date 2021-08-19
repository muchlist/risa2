import '../json_models/response/cctv_maintenance_resp.dart';
import '../json_models/response/error_resp.dart';
import '../json_models/response/main_maintenance_list_resp.dart';
import 'json_parsers.dart';

class CCTVMaintParser extends JsonParser<CCTVMaintDetailResponse>
    with ObjectDecoder<CCTVMaintDetailResponse> {
  const CCTVMaintParser();

  @override
  Future<CCTVMaintDetailResponse> parseFromJson(String json) async {
    try {
      final Map<String, dynamic> decoded = decodeJsonObject(json);
      return CCTVMaintDetailResponse.fromJson(decoded);
    } catch (e) {
      return CCTVMaintDetailResponse(
          ErrorResp(0, e.toString(), "", <String>[]), null);
    }
  }
}

class CCTVMaintListParser extends JsonParser<MainMaintenanceListResponse>
    with ObjectDecoder<MainMaintenanceListResponse> {
  const CCTVMaintListParser();

  @override
  Future<MainMaintenanceListResponse> parseFromJson(String json) async {
    try {
      final Map<String, dynamic> decoded = decodeJsonObject(json);
      return MainMaintenanceListResponse.fromJson(decoded);
    } catch (e) {
      return MainMaintenanceListResponse(
          ErrorResp(0, e.toString(), "", <String>[]), <MainMaintMinResponse>[]);
    }
  }
}
