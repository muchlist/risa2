import 'package:flutter/material.dart';
import 'package:risa2/src/api/json_models/response/check_resp.dart';

import '../api/filter_models/check_filter.dart';
import '../api/json_models/request/check_req.dart';
import '../api/json_models/response/check_list_resp.dart';
import '../api/services/check_service.dart';
import '../utils/enums.dart';

class CheckProvider extends ChangeNotifier {
  final CheckService _checkService;
  CheckProvider(this._checkService);

  // =======================================================
  // List Check

  // * state
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
    await findCheck();
    return true;
  }

  // ========================================================
  // detail check

  // * detail state
  ViewState _detailState = ViewState.idle;
  ViewState get detailState => _state;
  void setDetailState(ViewState viewState) {
    _detailState = viewState;
    notifyListeners();
  }

  String _checkIDSaved = "";
  void setCheckID(String checkID) {
    _checkIDSaved = checkID;
  }

  // check detail cache
  CheckDetailResponseData? _checkDetail;
  CheckDetailResponseData? get checkDetail {
    return _checkDetail;
  }

  // get detail check
  // * Mendapatkan check
  Future<void> getDetail() async {
    setDetailState(ViewState.busy);

    var error = "";
    try {
      final response = await _checkService.getCheck(_checkIDSaved);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _checkDetail = response.data;
      }
    } catch (e) {
      error = e.toString();
    }

    setState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future.error(error);
    }
  }
}
