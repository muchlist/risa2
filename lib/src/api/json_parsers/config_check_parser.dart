import '../json_models/response/config_check_list_resp.dart';
import '../json_models/response/config_check_resp.dart';

import '../json_models/response/error_resp.dart';

import 'json_parsers.dart';

class ConfigCheckParser extends JsonParser<ConfigCheckDetailResponse>
    with ObjectDecoder<ConfigCheckDetailResponse> {
  const ConfigCheckParser();

  @override
  Future<ConfigCheckDetailResponse> parseFromJson(String json) async {
    try {
      final Map<String, dynamic> decoded = decodeJsonObject(json);
      return ConfigCheckDetailResponse.fromJson(decoded);
    } catch (e) {
      return ConfigCheckDetailResponse(
          ErrorResp(0, e.toString(), "", <String>[]), null);
    }
  }
}

class ConfigCheckListParser extends JsonParser<ConfigCheckListResponse>
    with ObjectDecoder<ConfigCheckListResponse> {
  const ConfigCheckListParser();

  @override
  Future<ConfigCheckListResponse> parseFromJson(String json) async {
    try {
      final Map<String, dynamic> decoded = decodeJsonObject(json);
      return ConfigCheckListResponse.fromJson(decoded);
    } catch (e) {
      return ConfigCheckListResponse(ErrorResp(0, e.toString(), "", <String>[]),
          <ConfigCheckDetailResponseData>[]);
    }
  }
}
