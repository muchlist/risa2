import 'dart:collection';

import 'package:flutter/foundation.dart';
import '../api/filter_models/checkp_filter.dart';
import '../api/json_models/request/checkp_req.dart';
import '../api/json_models/response/checkp_list_resp.dart';
import '../api/json_models/response/checkp_resp.dart';
import '../api/services/checkp_service.dart';
import '../utils/enums.dart';

class CheckMasterProvider extends ChangeNotifier {
  final CheckpService _checkMasterService;
  CheckMasterProvider(this._checkMasterService);

  // =======================================================
  // List MasterCheck
  // * state
  ViewState _state = ViewState.idle;
  ViewState get state => _state;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  // check master list cache
  List<CheckpMinResponse> _checkpList = [];
  List<CheckpMinResponse> get checkpList {
    return UnmodifiableListView(_checkpList);
  }

  // *memasang filter pada pencarian check master
  FilterCheckp _filterCheck = FilterCheckp();
  void setFilter(FilterCheckp filter) {
    _filterCheck = filter;
  }

  // * Mendapatkan check
  Future<void> findCheckMaster() async {
    setState(ViewState.busy);

    var error = "";
    try {
      final response = await _checkMasterService.findCheckp(_filterCheck);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _checkpList = response.data;
      }
    } catch (e) {
      error = e.toString();
    }

    setState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future.error(error);
    }
  }

  // return future true jika add check master berhasil
  // memanggil findCheck sehingga tidak perlu notifyListener
  Future<bool> addCheck(CheckpRequest payload) async {
    setState(ViewState.busy);
    var error = "";

    try {
      final response = await _checkMasterService.createCheckp(payload);
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
    await findCheckMaster();
    return true;
  }

  // ========================================================
  // detail check

  // * detail state
  ViewState _detailState = ViewState.idle;
  ViewState get detailState => _detailState;
  void setDetailState(ViewState viewState) {
    _detailState = viewState;
    notifyListeners();
  }

  String _checkIDSaved = "";
  void setCheckID(String checkID) {
    _checkIDSaved = checkID;
  }

  // check detail cache
  CheckpDetailResponseData? _checkDetail;
  CheckpDetailResponseData? get checkDetail {
    return _checkDetail;
  }

  void removeDetail() {
    _checkDetail = null;
  }

  // get detail check
  // * Mendapatkan check
  Future<void> getDetail() async {
    setDetailState(ViewState.busy);

    var error = "";
    try {
      final response = await _checkMasterService.getCheckp(_checkIDSaved);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _checkDetail = response.data;
      }
    } catch (e) {
      error = e.toString();
    }

    setDetailState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future.error(error);
    }
  }

  void onClose() {
    removeDetail();
    _checkpList = [];
  }
}