import '../json_models/response/error_resp.dart';
import '../json_models/response/general_list_resp.dart';
import 'json_parsers.dart';

class GeneralListParser extends JsonParser<GeneralListResponse>
    with ObjectDecoder<GeneralListResponse> {
  const GeneralListParser();

  @override
  Future<GeneralListResponse> parseFromJson(String json) async {
    try {
      final decoded = decodeJsonObject(json);
      return GeneralListResponse.fromJson(decoded);
    } catch (e) {
      return GeneralListResponse(ErrorResp(0, e.toString(), "", []), []);
    }
  }
}
