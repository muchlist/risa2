import '../json_models/response/check_list_resp.dart';
import '../json_models/response/check_resp.dart';
import '../json_models/response/error_resp.dart';
import 'json_parsers.dart';

class CheckParser extends JsonParser<CheckDetailResponse>
    with ObjectDecoder<CheckDetailResponse> {
  const CheckParser();

  @override
  Future<CheckDetailResponse> parseFromJson(String json) async {
    try {
      final Map<String, dynamic> decoded = decodeJsonObject(json);
      return CheckDetailResponse.fromJson(decoded);
    } catch (e) {
      return CheckDetailResponse(
          ErrorResp(0, e.toString(), "", <String>[]), null);
    }
  }
}

class CheckListParser extends JsonParser<CheckListResponse>
    with ObjectDecoder<CheckListResponse> {
  const CheckListParser();

  @override
  Future<CheckListResponse> parseFromJson(String json) async {
    try {
      final Map<String, dynamic> decoded = decodeJsonObject(json);
      return CheckListResponse.fromJson(decoded);
    } catch (e) {
      return CheckListResponse(
          ErrorResp(0, e.toString(), "", <String>[]), <CheckMinResponse>[]);
    }
  }
}
