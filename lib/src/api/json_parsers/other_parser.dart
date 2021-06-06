import '../json_models/response/error_resp.dart';
import '../json_models/response/other_list_resp.dart';
import '../json_models/response/other_resp.dart';
import 'json_parsers.dart';

class OtherParser extends JsonParser<OtherDetailResponse>
    with ObjectDecoder<OtherDetailResponse> {
  const OtherParser();

  @override
  Future<OtherDetailResponse> parseFromJson(String json) async {
    try {
      final decoded = decodeJsonObject(json);
      return OtherDetailResponse.fromJson(decoded);
    } catch (e) {
      return OtherDetailResponse(ErrorResp(0, e.toString(), "", []), null);
    }
  }
}

class OtherListParser extends JsonParser<OtherListResponse>
    with ObjectDecoder<OtherListResponse> {
  const OtherListParser();

  @override
  Future<OtherListResponse> parseFromJson(String json) async {
    try {
      final decoded = decodeJsonObject(json);
      return OtherListResponse.fromJson(decoded);
    } catch (e) {
      return OtherListResponse(
          ErrorResp(0, e.toString(), "", []), OtherListData([], []));
    }
  }
}
