import 'package:risa2/src/api/http_client.dart';
import 'package:risa2/src/api/json_models/response/speed_list_resp.dart';
import 'package:risa2/src/api/json_parsers/json_parsers.dart';

class SpeedService {
  const SpeedService();
  Future<SpeedListResponse> retrieveSpeed() {
    return RequestREST(endpoint: "/speed-test")
        .executeGet<SpeedListResponse>(SpeedListParser());
  }
}
