import '../json_models/response/error_resp.dart';
import '../json_models/response/stock_list_resp.dart';
import '../json_models/response/stock_resp.dart';
import 'json_parsers.dart';

class StockParser extends JsonParser<StockDetailResponse>
    with ObjectDecoder<StockDetailResponse> {
  const StockParser();

  @override
  Future<StockDetailResponse> parseFromJson(String json) async {
    try {
      final decoded = decodeJsonObject(json);
      return StockDetailResponse.fromJson(decoded);
    } catch (e) {
      return StockDetailResponse(ErrorResp(0, json, "", []), null);
    }
  }
}

class StockListParser extends JsonParser<StockListResponse>
    with ObjectDecoder<StockListResponse> {
  const StockListParser();

  @override
  Future<StockListResponse> parseFromJson(String json) async {
    try {
      final decoded = decodeJsonObject(json);
      return StockListResponse.fromJson(decoded);
    } catch (e) {
      return StockListResponse(ErrorResp(0, json, "", []), []);
    }
  }
}
