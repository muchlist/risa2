import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:risa2/src/api/json_models/response/message_resp.dart';

import '../api/filter_models/checkp_filter.dart';
import '../api/json_models/option/location_type.dart';
import '../api/json_models/request/checkp_edit_req.dart';
import '../api/json_models/request/checkp_req.dart';
import '../api/json_models/response/checkp_list_resp.dart';
import '../api/json_models/response/checkp_resp.dart';
import '../api/services/checkp_service.dart';
import '../globals.dart';
import '../utils/enums.dart';

class CheckMasterProvider extends ChangeNotifier {
  CheckMasterProvider(this._checkMasterService);
  final CheckpService _checkMasterService;

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
  List<CheckpMinResponse> _checkpList = <CheckpMinResponse>[];
  List<CheckpMinResponse> get checkpList {
    return UnmodifiableListView<CheckpMinResponse>(_checkpList);
  }

  // *memasang filter pada pencarian check master
  FilterCheckp _filterCheck = FilterCheckp(branch: App.getBranch());
  void setFilter(FilterCheckp filter) {
    _filterCheck = filter;
  }

  // * Mendapatkan check
  Future<void> findCheckMaster() async {
    setState(ViewState.busy);

    String error = "";
    try {
      final CheckpListResponse response =
          await _checkMasterService.findCheckp(_filterCheck);
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
      return Future<void>.error(error);
    }
  }

  // return future true jika add check master berhasil
  // memanggil findCheck sehingga tidak perlu notifyListener
  Future<bool> addCheckMaster(CheckpRequest payload) async {
    setState(ViewState.busy);
    String error = "";

    try {
      final MessageResponse response =
          await _checkMasterService.createCheckp(payload);
      if (response.error != null) {
        error = response.error!.message;
      }
    } catch (e) {
      error = e.toString();
    }

    setState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future<bool>.error(error);
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
  Future<CheckpDetailResponseData> getDetail() async {
    setDetailState(ViewState.busy);

    late CheckpDetailResponseData responseData;
    String error = "";
    try {
      final CheckpDetailResponse response =
          await _checkMasterService.getCheckp(_checkIDSaved);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _checkDetail = response.data;
        responseData = response.data!;
      }
    } catch (e) {
      error = e.toString();
    }

    setDetailState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future<CheckpDetailResponseData>.error(error);
    }

    return responseData;
  }

  // edit master check
  Future<bool> editCheckMaster(CheckpEditRequest payload) async {
    setDetailState(ViewState.busy);
    String error = "";

    try {
      final CheckpDetailResponse response =
          await _checkMasterService.editCheckp(_checkIDSaved, payload);
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
      return Future<bool>.error(error);
    }
    await findCheckMaster();
    return true;
  }

  // remove master check
  Future<bool> removeCheckMaster() async {
    setDetailState(ViewState.busy);
    String error = "";

    try {
      final MessageResponse response =
          await _checkMasterService.deleteCheckp(_checkIDSaved);
      if (response.error != null) {
        error = response.error!.message;
      }
    } catch (e) {
      error = e.toString();
    }

    setDetailState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future<bool>.error(error);
    }
    await findCheckMaster();
    return true;
  }

  // check option cache
  OptLocationType _checkOption =
      OptLocationType(<String>["None"], <String>["None"]);
  OptLocationType get checkOption {
    return _checkOption;
  }

  // * Mendapatkan check option
  Future<void> findOptionCheckMaster() async {
    try {
      final OptLocationType response =
          await _checkMasterService.getOptCreateCheckp(App.getBranch() ?? "");
      _checkOption = response;
    } catch (e) {
      return Future<void>.error(e.toString());
    }
    notifyListeners();
  }

  void onClose() {
    removeDetail();
    _checkpList = <CheckpMinResponse>[];
  }
}
