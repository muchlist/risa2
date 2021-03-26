import 'package:risa2/src/api/json_models/response/improve_list_resp.dart';
import 'package:risa2/src/api/json_models/response/improve_resp.dart';

import '../json_models/response/error_resp.dart';

import 'json_parsers.dart';

class ImproveParser extends JsonParser<ImproveDetailResponse>
    with ObjectDecoder<ImproveDetailResponse> {
  const ImproveParser();

  @override
  Future<ImproveDetailResponse> parseFromJson(String json) async {
    try {
      final decoded = decodeJsonObject(json);
      return ImproveDetailResponse.fromJson(decoded);
    } catch (e) {
      return ImproveDetailResponse(ErrorResp(0, json, "", []), null);
    }
  }
}

class ImproveListParser extends JsonParser<ImproveListResponse>
    with ObjectDecoder<ImproveListResponse> {
  const ImproveListParser();

  @override
  Future<ImproveListResponse> parseFromJson(String json) async {
    try {
      final decoded = decodeJsonObject(json);
      return ImproveListResponse.fromJson(decoded);
    } catch (e) {
      return ImproveListResponse(ErrorResp(0, json, "", []), []);
    }
  }
}
