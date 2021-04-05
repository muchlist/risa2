import 'package:flutter/material.dart';

import '../api/filter_models/check_filter.dart';
import '../api/json_models/request/check_req.dart';
import '../api/json_models/response/check_list_resp.dart';
import '../api/services/check_service.dart';
import '../utils/enums.dart';

class CheckProvider extends ChangeNotifier {
  final CheckService _checkService;
  CheckProvider(this._checkService);

  ViewState _state = ViewState.idle;
  ViewState get state => _state;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  // check list cache
  List<CheckMinResponse> _checkList = [];
  List<CheckMinResponse> get checkList {
    return [..._checkList];
  }

  // *memasang filter pada pencarian check
  FilterCheck _filterCheck = FilterCheck();
  void setFilter(FilterCheck filter) {
    _filterCheck = filter;
  }

  // * Mendapatkan check
  Future<void> findCheck() async {
    setState(ViewState.busy);

    var error = "";
    try {
      final response = await _checkService.findCheck(_filterCheck);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _checkList = response.data;
      }
    } catch (e) {
      error = e.toString();
    }

    setState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future.error(error);
    }
  }

  // return future true jika add check berhasil
  // memanggil findCheck sehigga tidak perlu notifyListener
  Future<bool> addCheck(CheckRequest payload) async {
    setState(ViewState.busy);
    var error = "";

    try {
      final response = await _checkService.createCheck(payload);
      if (response.error != null) {
        error = response.error!.message;
      }
    } catch (e) {
      error = e.toString();
    }

    setState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future.error(error);
    }
    return true;
  }
}
