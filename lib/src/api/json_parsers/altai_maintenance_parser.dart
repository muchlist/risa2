import '../json_models/response/altai_maintenance_resp.dart';

import '../json_models/response/error_resp.dart';
import '../json_models/response/main_maintenance_list_resp.dart';
import 'json_parsers.dart';

class AltaiMaintParser extends JsonParser<AltaiMaintDetailResponse>
    with ObjectDecoder<AltaiMaintDetailResponse> {
  const AltaiMaintParser();

  @override
  Future<AltaiMaintDetailResponse> parseFromJson(String json) async {
    try {
      final Map<String, dynamic> decoded = decodeJsonObject(json);
      return AltaiMaintDetailResponse.fromJson(decoded);
    } catch (e) {
      return AltaiMaintDetailResponse(
          ErrorResp(0, e.toString(), "", <String>[]), null);
    }
  }
}

class AltaiMaintListParser extends JsonParser<MainMaintenanceListResponse>
    with ObjectDecoder<MainMaintenanceListResponse> {
  const AltaiMaintListParser();

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
