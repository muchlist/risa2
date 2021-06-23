import '../json_models/response/error_resp.dart';
import '../json_models/response/speed_list_resp.dart';
import 'json_parsers.dart';

class SpeedListParser extends JsonParser<SpeedListResponse>
    with ObjectDecoder<SpeedListResponse> {
  const SpeedListParser();

  @override
  Future<SpeedListResponse> parseFromJson(String json) async {
    try {
      final decoded = decodeJsonObject(json);
      return SpeedListResponse.fromJson(decoded);
    } catch (e) {
      return SpeedListResponse(ErrorResp(0, e.toString(), "", []), []);
    }
  }
}
