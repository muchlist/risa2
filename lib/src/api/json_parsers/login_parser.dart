import '../json_models/response/error_resp.dart';
import '../json_models/response/login_resp.dart';

import 'json_parsers.dart';

class LoginParser extends JsonParser<LoginResponse>
    with ObjectDecoder<LoginResponse> {
  const LoginParser();

  @override
  Future<LoginResponse> parseFromJson(String json) async {
    try {
      final decoded = decodeJsonObject(json);
      return LoginResponse.fromJson(decoded);
    } catch (e) {
      return LoginResponse(ErrorResp(0, e.toString(), "", []), null);
    }
  }
}
