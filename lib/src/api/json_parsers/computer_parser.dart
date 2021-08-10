import '../json_models/response/computer_list_resp.dart';
import '../json_models/response/computer_resp.dart';
import '../json_models/response/error_resp.dart';
import '../json_models/response/general_list_resp.dart';
import 'json_parsers.dart';

class ComputerParser extends JsonParser<ComputerDetailResponse>
    with ObjectDecoder<ComputerDetailResponse> {
  const ComputerParser();

  @override
  Future<ComputerDetailResponse> parseFromJson(String json) async {
    try {
      final Map<String, dynamic> decoded = decodeJsonObject(json);
      return ComputerDetailResponse.fromJson(decoded);
    } catch (e) {
      return ComputerDetailResponse(
          ErrorResp(0, e.toString(), "", <String>[]), null);
    }
  }
}

class ComputerListParser extends JsonParser<ComputerListResponse>
    with ObjectDecoder<ComputerListResponse> {
  const ComputerListParser();

  @override
  Future<ComputerListResponse> parseFromJson(String json) async {
    try {
      final Map<String, dynamic> decoded = decodeJsonObject(json);
      return ComputerListResponse.fromJson(decoded);
    } catch (e) {
      return ComputerListResponse(ErrorResp(0, e.toString(), "", <String>[]),
          ComputerListData(<ComputerMinResponse>[], <GeneralMinResponse>[]));
    }
  }
}
