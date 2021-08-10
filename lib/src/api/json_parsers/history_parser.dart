import '../json_models/response/error_resp.dart';
import '../json_models/response/history_list_resp.dart';
import '../json_models/response/history_resp.dart';
import 'json_parsers.dart';

class HistoryParser extends JsonParser<HistoryDetailResponse>
    with ObjectDecoder<HistoryDetailResponse> {
  const HistoryParser();

  @override
  Future<HistoryDetailResponse> parseFromJson(String json) async {
    try {
      final Map<String, dynamic> decoded = decodeJsonObject(json);
      return HistoryDetailResponse.fromJson(decoded);
    } catch (e) {
      return HistoryDetailResponse(
          ErrorResp(0, e.toString(), "", <String>[]), null);
    }
  }
}

class HistoryListParser extends JsonParser<HistoryListResponse>
    with ObjectDecoder<HistoryListResponse> {
  const HistoryListParser();

  @override
  Future<HistoryListResponse> parseFromJson(String json) async {
    try {
      final Map<String, dynamic> decoded = decodeJsonObject(json);
      return HistoryListResponse.fromJson(decoded);
    } catch (e) {
      return HistoryListResponse(
          ErrorResp(0, e.toString(), "", <String>[]), <HistoryMinResponse>[]);
    }
  }
}
