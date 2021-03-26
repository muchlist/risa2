import 'package:risa2/src/api/json_models/response/improve_list_resp.dart';

import '../filter_models/improve_filter.dart';

import '../http_client.dart';
import '../json_models/response/improve_resp.dart';
import '../json_parsers/improve_parser.dart';

class ImproveService {
  const ImproveService();

  Future<ImproveDetailResponse> getImprove(String id) {
    return RequestREST(endpoint: "/improve/$id")
        .executeGet<ImproveDetailResponse>(ImproveParser());
  }

  Future<ImproveListResponse> findImprove(FilterImporve f) {
    var query = "";
    if (f.branch != null) {
      query = query + "branch=${f.branch}&";
    }
    if (f.completeStatus != null) {
      query = query + "c_status=${f.completeStatus}&";
    }
    if (f.start != null) {
      query = query + "start=${f.start}&";
    }
    if (f.end != null) {
      query = query + "end=${f.end}&";
    }
    if (f.limit != null) {
      query = query + "limit=${f.limit}";
    }

    return RequestREST(endpoint: "/improve?$query")
        .executeGet<ImproveListResponse>(ImproveListParser());
  }
}
