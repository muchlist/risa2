import '../json_models/response/cctv_list_resp.dart';
import '../json_models/response/cctv_resp.dart';
import '../json_models/response/error_resp.dart';
import 'json_parsers.dart';

class CctvParser extends JsonParser<CctvDetailResponse>
    with ObjectDecoder<CctvDetailResponse> {
  const CctvParser();

  @override
  Future<CctvDetailResponse> parseFromJson(String json) async {
    try {
      final decoded = decodeJsonObject(json);
      return CctvDetailResponse.fromJson(decoded);
    } catch (e) {
      return CctvDetailResponse(ErrorResp(0, e.toString(), "", []), null);
    }
  }
}

class CctvListParser extends JsonParser<CctvListResponse>
    with ObjectDecoder<CctvListResponse> {
  const CctvListParser();

  @override
  Future<CctvListResponse> parseFromJson(String json) async {
    try {
      final decoded = decodeJsonObject(json);
      return CctvListResponse.fromJson(decoded);
    } catch (e) {
      return CctvListResponse(ErrorResp(0, e.toString(), "", []), []);
    }
  }
}
