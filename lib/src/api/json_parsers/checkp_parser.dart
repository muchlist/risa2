import '../json_models/response/checkp_list_resp.dart';
import '../json_models/response/checkp_resp.dart';

import '../json_models/response/error_resp.dart';
import 'json_parsers.dart';

class CheckpParser extends JsonParser<CheckpDetailResponse>
    with ObjectDecoder<CheckpDetailResponse> {
  const CheckpParser();

  @override
  Future<CheckpDetailResponse> parseFromJson(String json) async {
    try {
      final decoded = decodeJsonObject(json);
      return CheckpDetailResponse.fromJson(decoded);
    } catch (e) {
      return CheckpDetailResponse(ErrorResp(0, e.toString(), "", []), null);
    }
  }
}

class CheckpListParser extends JsonParser<CheckpListResponse>
    with ObjectDecoder<CheckpListResponse> {
  const CheckpListParser();

  @override
  Future<CheckpListResponse> parseFromJson(String json) async {
    try {
      final decoded = decodeJsonObject(json);
      return CheckpListResponse.fromJson(decoded);
    } catch (e) {
      return CheckpListResponse(ErrorResp(0, e.toString(), "", []), []);
    }
  }
}
