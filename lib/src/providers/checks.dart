import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:risa2/src/api/json_models/response/message_resp.dart';

import '../api/filter_models/check_filter.dart';
import '../api/json_models/request/check_edit_req.dart';
import '../api/json_models/request/check_req.dart';
import '../api/json_models/request/check_update_req.dart';
import '../api/json_models/response/check_list_resp.dart';
import '../api/json_models/response/check_resp.dart';
import '../api/services/check_service.dart';
import '../globals.dart';
import '../utils/enums.dart';
import '../utils/image_compress.dart';

class CheckProvider extends ChangeNotifier {
  CheckProvider(this._checkService);
  final CheckService _checkService;

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
  List<CheckMinResponse> _checkList = <CheckMinResponse>[];
  List<CheckMinResponse> get checkList {
    return UnmodifiableListView<CheckMinResponse>(_checkList);
  }

  // *memasang filter pada pencarian check
  FilterCheck _filterCheck = FilterCheck(branch: App.getBranch());
  void setFilter(FilterCheck filter) {
    _filterCheck = filter;
  }

  // * Mendapatkan check
  Future<void> findCheck() async {
    setState(ViewState.busy);

    String error = "";
    try {
      final CheckListResponse response =
          await _checkService.findCheck(_filterCheck);
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
      return Future<void>.error(error);
    }
  }

  // return future true jika add check berhasil
  // memanggil findCheck sehigga tidak perlu notifyListener
  Future<bool> addCheck(CheckRequest payload) async {
    setState(ViewState.busy);
    String error = "";

    try {
      final MessageResponse response = await _checkService.createCheck(payload);
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
    await findCheck();
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
  CheckDetailResponseData? _checkDetail;
  CheckDetailResponseData? get checkDetail {
    return _checkDetail;
  }

  void removeDetail() {
    _checkDetail = null;
  }

  // get detail check
  // * Mendapatkan check
  Future<void> getDetail() async {
    setDetailState(ViewState.busy);

    String error = "";
    try {
      final CheckDetailResponse response =
          await _checkService.getCheck(_checkIDSaved);
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
      return Future<void>.error(error);
    }
  }

  // =====================================================================
  // child check

  ViewState _childState = ViewState.idle;
  ViewState get childState => _childState;
  void setChildState(ViewState viewState) {
    _childState = viewState;
    notifyListeners();
  }

// * update child
// return future true jika update check berhasil
  Future<bool> updateChildCheck(CheckUpdateRequest payload) async {
    setChildState(ViewState.busy);
    String error = "";

    try {
      final CheckDetailResponse response =
          await _checkService.updateCheck(payload);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _checkDetail = response.data;
      }
    } catch (e) {
      error = e.toString();
    }

    setChildState(ViewState.idle);

    if (error.isNotEmpty) {
      return Future<bool>.error(error);
    }
    return true;
  }

  // * update child image
  // return future true jika update check image berhasil
  Future<bool> uploadChildCheck(String id, String childID, File file) async {
    setChildState(ViewState.busy);
    String error = "";

    final File fileCompressed = await compressFile(file);

    try {
      final CheckDetailResponse response =
          await _checkService.uploadImage(id, childID, fileCompressed);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _checkDetail = response.data;
      }
    } catch (e) {
      error = e.toString();
    }

    setChildState(ViewState.idle);

    if (error.isNotEmpty) {
      return Future<bool>.error(error);
    }
    return true;
  }

  // * =======================================================
  // Check Edit
  // return future true jika edit check berhasil
  // memanggil findCheck sehigga tidak perlu notifyListener
  Future<bool> completeCheck() async {
    setDetailState(ViewState.busy);
    String error = "";

    try {
      final CheckDetailResponse response = await _checkService.editCheck(
          _checkDetail?.id ?? "", CheckEditRequest(isFinish: true, note: ""));
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
    await findCheck();
    return true;
  }

  // return future true jika delete check berhasil
  // memanggil findCheck sehigga tidak perlu notifyListener
  Future<bool> deleteCheck() async {
    setState(ViewState.busy);
    String error = "";

    try {
      final MessageResponse response =
          await _checkService.deleteCheck(_checkIDSaved);
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
    await findCheck();
    return true;
  }

  // dipanggil ketika data sudah tidak dibutuhkan lagi,
  // di on dispose
  void onClose() {
    removeDetail();
    _checkList = <CheckMinResponse>[];
  }
}
