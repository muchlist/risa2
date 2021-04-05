import 'package:flutter/material.dart';
import 'package:risa2/src/api/filter_models/history_filter.dart';
import 'package:risa2/src/api/json_models/request/history_req.dart';
import 'package:risa2/src/api/json_models/response/history_list_resp.dart';
import 'package:risa2/src/api/services/history_service.dart';

class HistoryProvider extends ChangeNotifier {
  final HistoryService historyService;
  HistoryProvider(this.historyService);

  List<HistoryMinResponse> _historyList = [];

  List<HistoryMinResponse> get historyListDashboard {
    if (_historyList.length > 2) {
      return [..._historyList.sublist(0, 3)];
    }
    return [..._historyList];
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

  // return future true jika add history berhasil
  // memanggil findHistory sehigga tidak perlu notifyListener
  Future<bool> addHistory(HistoryRequest payload) {
    return HistoryService().createHistory(payload).then(
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
