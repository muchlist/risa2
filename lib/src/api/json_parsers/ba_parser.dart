import '../json_models/response/ba_list_resp.dart';
import '../json_models/response/ba_resp.dart';
import '../json_models/response/error_resp.dart';
import 'json_parsers.dart';

class BaParser extends JsonParser<BaDetailResponse>
    with ObjectDecoder<BaDetailResponse> {
  const BaParser();

  @override
  Future<BaDetailResponse> parseFromJson(String json) async {
    try {
      final Map<String, dynamic> decoded = decodeJsonObject(json);
      return BaDetailResponse.fromJson(decoded);
    } catch (e) {
      return BaDetailResponse(ErrorResp(0, e.toString(), "", <String>[]), null);
    }
  }
}

class BaListParser extends JsonParser<BaListResponse>
    with ObjectDecoder<BaListResponse> {
  const BaListParser();

  @override
  Future<BaListResponse> parseFromJson(String json) async {
    try {
      final Map<String, dynamic> decoded = decodeJsonObject(json);
      return BaListResponse.fromJson(decoded);
    } catch (e) {
      return BaListResponse(
          ErrorResp(0, e.toString(), "", <String>[]), <BaMinResponse>[]);
    }
  }
}
