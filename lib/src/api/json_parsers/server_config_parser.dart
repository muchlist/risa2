import '../json_models/response/error_resp.dart';
import '../json_models/response/server_config_list_resp.dart';
import '../json_models/response/server_config_resp.dart';
import 'json_parsers.dart';

class ServerConfigParser extends JsonParser<ServerConfigDetailResponse>
    with ObjectDecoder<ServerConfigDetailResponse> {
  const ServerConfigParser();

  @override
  Future<ServerConfigDetailResponse> parseFromJson(String json) async {
    try {
      final Map<String, dynamic> decoded = decodeJsonObject(json);
      return ServerConfigDetailResponse.fromJson(decoded);
    } catch (e) {
      return ServerConfigDetailResponse(
          ErrorResp(0, e.toString(), "", <String>[]), null);
    }
  }
}

class ServerConfigListParser extends JsonParser<ServerConfigListResponse>
    with ObjectDecoder<ServerConfigListResponse> {
  const ServerConfigListParser();

  @override
  Future<ServerConfigListResponse> parseFromJson(String json) async {
    try {
      final Map<String, dynamic> decoded = decodeJsonObject(json);
      return ServerConfigListResponse.fromJson(decoded);
    } catch (e) {
      return ServerConfigListResponse(
          ErrorResp(0, e.toString(), "", <String>[]), <ServerConfigResponse>[]);
    }
  }
}
