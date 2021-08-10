import '../http_client.dart';
import '../json_models/response/speed_list_resp.dart';
import '../json_parsers/json_parsers.dart';

class SpeedService {
  const SpeedService();
  Future<SpeedListResponse> retrieveSpeed() {
    return RequestREST(endpoint: "/speed-test")
        .executeGet<SpeedListResponse>(const SpeedListParser());
  }
}
