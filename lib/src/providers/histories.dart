import 'dart:collection';

import 'package:flutter/material.dart';

import '../api/filter_models/history_filter.dart';
import '../api/json_models/request/history_req.dart';
import '../api/json_models/response/history_list_resp.dart';
import '../api/services/history_service.dart';
import '../utils/enums.dart';

class HistoryProvider extends ChangeNotifier {
  final HistoryService _historyService;
  HistoryProvider(this._historyService);

  ViewState _state = ViewState.idle;
  ViewState get state => _state;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  List<HistoryMinResponse> _historyList = [];

  // 3 history terbaru
  List<HistoryMinResponse> get historyListDashboard {
    if (_historyList.length > 2) {
      return [..._historyList.sublist(0, 3)];
    }
    return UnmodifiableListView(_historyList);
  }

  // history progress
  List<HistoryMinResponse> get historyProgressList {
    return _historyList.where((hist) {
      return hist.completeStatus == enumStatus.progress.index ||
          hist.completeStatus == enumStatus.rpending.index;
    }).toList();
  }

  // history pending
  List<HistoryMinResponse> get historyPendingList {
    return _historyList
        .where((hist) => hist.completeStatus == enumStatus.pending.index)
        .toList();
  }

  // history all
  List<HistoryMinResponse> get historyList {
    return UnmodifiableListView(_historyList);
  }

  Future<void> findHistory({bool loading = true}) async {
    // create filter
    final filter = FilterHistory(branch: "BANJARMASIN", limit: 200);

    if (loading) {
      setState(ViewState.busy);
    }

    var error = "";
    try {
      final response = await _historyService.findHistory(filter);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _historyList = response.data;
      }
    } catch (e) {
      error = e.toString();
    }

    setState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future.error(error);
    }
  }

  // return future true jika add history berhasil
  // memanggil findHistory sehigga tidak perlu notifyListener
  // jika parentID di isi maka akan memanggil findParentHistory
  Future<bool> addHistory(HistoryRequest payload,
      {String parentID = ""}) async {
    setState(ViewState.busy);

    var error = "";
    try {
      final response = await _historyService.createHistory(payload);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        if (parentID.isNotEmpty) {
          await findParentHistory(parentID: parentID, loading: false);
          await findHistory(loading: false);
        } else {
          await findHistory(loading: false);
        }
        return true;
      }
    } catch (e) {
      error = e.toString();
    }

    setState(ViewState.idle);

    if (error.isNotEmpty) {
      return Future.error(error);
    }
    return false;
  }

  // ** PARENT HISTORY -----------------------------------------------------
  List<HistoryMinResponse> _parentHistory = [];

  List<HistoryMinResponse> get parentHistory {
    return UnmodifiableListView(_parentHistory);
  }

  void clearParentHistory() {
    _parentHistory = [];
  }

  Future<void> findParentHistory(
      {required String parentID, bool loading = true}) async {
    if (loading) {
      setState(ViewState.busy);
    }
    var error = "";
    try {
      final response = await _historyService.findHistoryFromParent(parentID);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _parentHistory = response.data;
      }
    } catch (e) {
      error = e.toString();
    }

    setState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future.error(error);
    }
  }

  String getLabelStatus(double number) {
    switch (number.toInt()) {
      case 1:
        return "Progress";
      case 2:
        return "Req Pending";
      case 3:
        return "Pending";
      case 4:
        return "Completed";
      default:
        return "Progress";
    }
  }
}
