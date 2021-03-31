import 'package:flutter/material.dart';
import 'package:risa2/src/api/filter_models/history_filter.dart';
import 'package:risa2/src/api/json_models/response/history_list_resp.dart';
import 'package:risa2/src/api/services/history_service.dart';

class HistoryProvider extends ChangeNotifier {
  List<HistoryMinResponse> _historyList = [];
  List<HistoryMinResponse> get historyList {
    if (_historyList.length > 2) {
      return [..._historyList.sublist(0, 3)];
    }
    return [..._historyList];
  }

  Future<void> findHistory() {
    final filter = FilterHistory(branch: "BANJARMASIN", limit: 100);
    return HistoryService().findHistory(filter).then(
      (response) {
        print(response.data.length.toString());
        if (response.data.length != 0) {
          _historyList = response.data;
        } else if (response.error != null) {
          return Future.error(response.error!.message);
        }
        notifyListeners();
      },
    );
  }
}
