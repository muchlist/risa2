import 'package:risa2/src/api/json_models/error_resp.dart';
import 'package:risa2/src/api/json_models/login_resp.dart';

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
      return LoginResponse(ErrorResp(0, json, "", []), null);
    }
  }
}
