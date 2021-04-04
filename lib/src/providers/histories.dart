import 'package:flutter/material.dart';
import 'package:risa2/src/api/filter_models/history_filter.dart';
import 'package:risa2/src/api/json_models/response/history_list_resp.dart';
import 'package:risa2/src/api/services/history_service.dart';

enum enumHistory { loading, loaded, error }

class HistoryProvider extends ChangeNotifier {
  List<HistoryMinResponse> _historyList = [];

  List<HistoryMinResponse> get historyListDashboard {
    if (_historyList.length > 2) {
      return [..._historyList.sublist(0, 3)];
    }
    return [..._historyList];
  }

  enumHistory _historyState = enumHistory.loading;
  enumHistory get historyState {
    return _historyState;
  }

  Future<void> findHistory() {
    final filter = FilterHistory(branch: "BANJARMASIN", limit: 100);
    return HistoryService().findHistory(filter).then(
      (response) {
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
