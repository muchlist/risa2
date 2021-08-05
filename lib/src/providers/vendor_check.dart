import 'dart:collection';

import 'package:flutter/material.dart';
import '../api/filter_models/check_filter.dart';
import '../api/json_models/request/vendor_req.dart';
import '../api/json_models/response/vendor_check_list_resp.dart';
import '../api/json_models/response/vendor_check_resp.dart';
import '../api/services/vendor_service.dart';

import '../globals.dart';
import '../utils/enums.dart';

class VendorCheckProvider extends ChangeNotifier {
  final VendorCheckService _vendorCheckService;
  VendorCheckProvider(this._vendorCheckService);

  // =======================================================
  // List VendorCheck

  // * state
  ViewState _state = ViewState.idle;
  ViewState get state => _state;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  // vendorCheck list cache
  List<VendorCheckMinResponse> _vendorCheckList = [];
  List<VendorCheckMinResponse> get vendorCheckList {
    return UnmodifiableListView(_vendorCheckList);
  }

  // vendorCheck list virtual cache
  List<VendorCheckMinResponse> get vendorCheckListVirtual {
    return _vendorCheckList.where((element) => element.isVirtualCheck).toList();
  }

  // vendorCheck list virtual cache
  List<VendorCheckMinResponse> get vendorCheckListPhyshic {
    return _vendorCheckList
        .where((element) => !element.isVirtualCheck)
        .toList();
  }

  // *memasang filter pada pencarian vendorCheck
  FilterCheck _filterVendorCheck = FilterCheck(branch: App.getBranch());
  void setFilter(FilterCheck filter) {
    _filterVendorCheck = filter;
  }

  // * Mendapatkan vendorChecks
  Future<void> findVendorCheck() async {
    setState(ViewState.busy);

    var error = "";
    try {
      final response =
          await _vendorCheckService.findVendorCheck(_filterVendorCheck);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _vendorCheckList = response.data;
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
      final response = await _vendorCheckService.createVendorCheck(isVirtual);
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

  String _vendorCheckIDSaved = "";
  void setVendorCheckID(String vendorCheckID) {
    _vendorCheckIDSaved = vendorCheckID;
  }

  // vendorVendorCheck detail cache
  VendorCheckDetailResponseData? _vendorCheckDetail;
  VendorCheckDetailResponseData get vendorCheckDetail {
    if (_vendorCheckDetail == null) {
      return VendorCheckDetailResponseData(
          "", 0, "", "", 0, "", "", "", 0, 0, false, false, "", []);
    }
    return _vendorCheckDetail!;
  }

  void removeDetail() {
    _vendorCheckDetail = null;
  }

  // get detail vendorVendorCheck
  // * Mendapatkan vendorVendorCheck
  Future<void> getDetail() async {
    setDetailState(ViewState.busy);

    var error = "";
    try {
      final response =
          await _vendorCheckService.getVendorCheck(_vendorCheckIDSaved);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _vendorCheckDetail = response.data;
      }
    } catch (e) {
      error = e.toString();
    }

    setDetailState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future.error(error);
    }
  }

  // =============================
  // get distinct location
  List<String> getLocationList() {
    var checkItems =
        _vendorCheckDetail?.vendorCheckItems ?? <VendorCheckItem>[];
    var allLocation = <String>[];
    if (checkItems.isEmpty) {
      return <String>[];
    }
    for (final check in checkItems) {
      allLocation.add(check.location);
    }
    return allLocation.toSet().toList();
  }

  Map<String, List<VendorCheckItem>> getCheckItemPerLocation(
      List<String> locations) {
    var checkMap = Map<String, List<VendorCheckItem>>();
    if (_vendorCheckDetail == null) {
      return checkMap;
    }
    for (final loc in locations) {
      checkMap[loc] = _vendorCheckDetail!.vendorCheckItems
          .where((cctv) => cctv.location == loc)
          .toList();
    }
    return checkMap;
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
      final response = await _vendorCheckService.updateVendorCheck(payload);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _vendorCheckDetail = response.data;
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
      final response =
          await _vendorCheckService.finishVendorCheck(_vendorCheckIDSaved);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _vendorCheckDetail = response.data;
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

  // return future true jika delete vendorVendorCheck berhasil
  // memanggil findVendorCheck sehigga tidak perlu notifyListener
  Future<bool> deleteVendorCheck() async {
    setState(ViewState.busy);
    var error = "";

    try {
      final response =
          await _vendorCheckService.deleteVendorCheck(_vendorCheckIDSaved);
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

  // dipanggil ketika data sudah tidak dibutuhkan lagi,
  // di on dispose
  void onClose() {
    removeDetail();
    _vendorCheckList = [];
  }
}
