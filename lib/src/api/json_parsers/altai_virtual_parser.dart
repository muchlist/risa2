import '../json_models/response/altai_virtual_list_resp.dart';
import '../json_models/response/altai_virtual_resp.dart';

import '../json_models/response/error_resp.dart';

import 'json_parsers.dart';

class AltaiVirtualParser extends JsonParser<AltaiVirtualDetailResponse>
    with ObjectDecoder<AltaiVirtualDetailResponse> {
  const AltaiVirtualParser();

  @override
  Future<AltaiVirtualDetailResponse> parseFromJson(String json) async {
    try {
      final Map<String, dynamic> decoded = decodeJsonObject(json);
      return AltaiVirtualDetailResponse.fromJson(decoded);
    } catch (e) {
      return AltaiVirtualDetailResponse(
          ErrorResp(0, e.toString(), "", <String>[]), null);
    }
  }
}

class AltaiVirtualListParser extends JsonParser<AltaiVirtualListResponse>
    with ObjectDecoder<AltaiVirtualListResponse> {
  const AltaiVirtualListParser();

  @override
  Future<AltaiVirtualListResponse> parseFromJson(String json) async {
    try {
      final Map<String, dynamic> decoded = decodeJsonObject(json);
      return AltaiVirtualListResponse.fromJson(decoded);
    } catch (e) {
      return AltaiVirtualListResponse(
          ErrorResp(0, e.toString(), "", <String>[]),
          <AltaiVirtualMinResponse>[]);
    }
  }
}
