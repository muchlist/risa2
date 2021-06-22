import 'dart:collection';

import 'package:flutter/cupertino.dart';
import '../api/json_models/response/speed_list_resp.dart';
import '../api/services/speed_service.dart';
import '../utils/utils.dart';

class DashboardProvider extends ChangeNotifier {
  final SpeedService _speedService;
  DashboardProvider(this._speedService);

  // =======================================================
  // List Dashboard

  // * state
  ViewState _state = ViewState.idle;
  ViewState get state => _state;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  // speed list cache
  List<SpeedData> _speedList = [];
  List<SpeedData> get speedList {
    return UnmodifiableListView(_speedList);
  }

  List<SpeedData> get lastTeenSpeedList {
    if (_speedList.length <= 10) {
      return UnmodifiableListView(_speedList);
    }
    return UnmodifiableListView(
        speedList.sublist(speedList.length - 1 - 10).toList());
  }

  // * Mendapatkan dashboard
  Future<void> retrieveSpeed({bool loading = true}) async {
    if (loading) {
      setState(ViewState.busy);
    }

    var error = "";
    try {
      final response = await _speedService.retrieveSpeed();
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _speedList = response.data;
      }
    } catch (e) {
      error = e.toString();
    }

    setState(ViewState.idle);

    if (error.isNotEmpty) {
      return Future.error(error);
    }
  }

  // dipanggil ketika data sudah tidak dibutuhkan lagi,
  // di on dispose
  void onClose() {
    _speedList = [];
  }
}
