import '../filter_models/general_filter.dart';
import '../http_client.dart';
import '../json_models/response/general_list_resp.dart';
import '../json_parsers/json_parsers.dart';

class GeneralService {
  const GeneralService();

  Future<GeneralListResponse> findGeneral(FilterGeneral f) {
    var query = "";
    if (f.ip != null) {
      query = query + "ip=${f.ip}&";
    }
    if (f.name != null) {
      query = query + "name=${f.name}&";
    }
    if (f.category != null) {
      query = query + "category=${f.category}&";
    }
    if (f.pings != null) {
      query = query + "pings=${f.pings}";
    }

    return RequestREST(endpoint: "/general?$query")
        .executeGet<GeneralListResponse>(GeneralListParser());
  }
}
