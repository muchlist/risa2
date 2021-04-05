import 'package:flutter/material.dart';
import '../api/filter_models/history_filter.dart';
import '../api/json_models/request/history_req.dart';
import '../api/json_models/response/history_list_resp.dart';
import '../api/services/history_service.dart';

class HistoryProvider extends ChangeNotifier {
  final HistoryService _historyService;
  HistoryProvider(this._historyService);

  List<HistoryMinResponse> _historyList = [];

  List<HistoryMinResponse> get historyListDashboard {
    if (_historyList.length > 2) {
      return [..._historyList.sublist(0, 3)];
    }
    return [..._historyList];
  }

  Future<void> findHistory() {
    final filter = FilterHistory(branch: "BANJARMASIN", limit: 100);
    return _historyService.findHistory(filter).then(
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

  // return future true jika add history berhasil
  // memanggil findHistory sehigga tidak perlu notifyListener
  Future<bool> addHistory(HistoryRequest payload) {
    return _historyService.createHistory(payload).then(
      (response) {
        if (response.error != null) {
          return Future.error(response.error!.message);
        } else if (response.data != null) {
          findHistory();
          return true;
        }
        return false;
      },
    );
  }
}
