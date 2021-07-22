import 'dart:collection';

import 'package:flutter/material.dart';
import '../api/filter_models/check_filter.dart';
import '../api/json_models/request/vendor_req.dart';
import '../api/json_models/response/vendor_check_list_resp.dart';
import '../api/json_models/response/vendor_check_resp.dart';
import '../api/services/vendor_service.dart';

import '../utils/enums.dart';

class VendorCheckProvider extends ChangeNotifier {
  final VendorCheckService _vendorVendorCheckService;
  VendorCheckProvider(this._vendorVendorCheckService);

  // =======================================================
  // List VendorCheck

  // * state
  ViewState _state = ViewState.idle;
  ViewState get state => _state;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  // vendorVendorCheck list cache
  List<VendorCheckMinResponse> _vendorVendorCheckList = [];
  List<VendorCheckMinResponse> get vendorVendorCheckList {
    return UnmodifiableListView(_vendorVendorCheckList);
  }

  // *memasang filter pada pencarian vendorVendorCheck
  FilterCheck _filterVendorCheck = FilterCheck();
  void setFilter(FilterCheck filter) {
    _filterVendorCheck = filter;
  }

  // * Mendapatkan vendorChecks
  Future<void> findVendorCheck() async {
    setState(ViewState.busy);

    var error = "";
    try {
      final response =
          await _vendorVendorCheckService.findVendorCheck(_filterVendorCheck);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _vendorVendorCheckList = response.data;
      }
    } catch (e) {
      error = e.toString();
    }

    setState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future.error(error);
    }
  }

  // return future true jika add vendorVendorCheck berhasil
  // memanggil findVendorCheck sehigga tidak perlu notifyListener
  Future<bool> addVendorCheck(bool isVirtual) async {
    setState(ViewState.busy);
    var error = "";

    try {
      final response =
          await _vendorVendorCheckService.createVendorCheck(isVirtual);
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
    await findVendorCheck();
    return true;
  }

  // ========================================================
  // detail vendorVendorCheck

  // * detail state
  ViewState _detailState = ViewState.idle;
  ViewState get detailState => _detailState;
  void setDetailState(ViewState viewState) {
    _detailState = viewState;
    notifyListeners();
  }

  String _vendorVendorCheckIDSaved = "";
  void setVendorCheckID(String vendorVendorCheckID) {
    _vendorVendorCheckIDSaved = vendorVendorCheckID;
  }

  // vendorVendorCheck detail cache
  VendorCheckDetailResponseData? _vendorVendorCheckDetail;
  VendorCheckDetailResponseData? get vendorVendorCheckDetail {
    return _vendorVendorCheckDetail;
  }

  void removeDetail() {
    _vendorVendorCheckDetail = null;
  }

  // get detail vendorVendorCheck
  // * Mendapatkan vendorVendorCheck
  Future<void> getDetail() async {
    setDetailState(ViewState.busy);

    var error = "";
    try {
      final response = await _vendorVendorCheckService
          .getVendorCheck(_vendorVendorCheckIDSaved);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _vendorVendorCheckDetail = response.data;
      }
    } catch (e) {
      error = e.toString();
    }

    setDetailState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future.error(error);
    }
  }

  // =====================================================================
  // child vendorVendorCheck

  ViewState _childState = ViewState.idle;
  ViewState get childState => _childState;
  void setChildState(ViewState viewState) {
    _childState = viewState;
    notifyListeners();
  }

// * update child
// return future true jika update vendorVendorCheck berhasil
  Future<bool> updateChildVendorCheck(VendorUpdateRequest payload) async {
    setChildState(ViewState.busy);
    var error = "";

    try {
      final response =
          await _vendorVendorCheckService.updateVendorCheck(payload);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _vendorVendorCheckDetail = response.data;
      }
    } catch (e) {
      error = e.toString();
    }

    setChildState(ViewState.idle);

    if (error.isNotEmpty) {
      return Future.error(error);
    }
    return true;
  }

  // * =======================================================
  // return future true jika completeVendorCheck berhasil
  // memanggil findVendorCheck sehigga tidak perlu notifyListener
  Future<bool> completeVendorCheck() async {
    setDetailState(ViewState.busy);
    var error = "";

    try {
      final response = await _vendorVendorCheckService
          .finishVendorCheck(_vendorVendorCheckIDSaved);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _vendorVendorCheckDetail = response.data;
      }
    } catch (e) {
      error = e.toString();
    }

    setDetailState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future.error(error);
    }
    await findVendorCheck();
    return true;
  }

  // dipanggil ketika data sudah tidak dibutuhkan lagi,
  // di on dispose
  void onClose() {
    removeDetail();
    _vendorVendorCheckList = [];
  }
}
