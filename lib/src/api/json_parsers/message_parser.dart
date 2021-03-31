import '../json_models/response/error_resp.dart';
import '../json_models/response/message_resp.dart';
import 'json_parsers.dart';

class MessageParser extends JsonParser<MessageResponse>
    with ObjectDecoder<MessageResponse> {
  const MessageParser();

  @override
  Future<MessageResponse> parseFromJson(String json) async {
    try {
      final decoded = decodeJsonObject(json);
      return MessageResponse.fromJson(decoded);
    } catch (e) {
      return MessageResponse(ErrorResp(0, e.toString(), "", []), null);
    }
  }
}
