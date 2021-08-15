import 'dart:collection';

import 'package:flutter/material.dart';

import '../api/filter_models/check_filter.dart';
import '../api/json_models/request/cctv_maintenance_req.dart';
import '../api/json_models/response/cctv_maintenance_resp.dart';
import '../api/json_models/response/main_maintenance_list_resp.dart';
import '../api/json_models/response/message_resp.dart';
import '../api/services/cctv_maint_service.dart';
import '../globals.dart';
import '../utils/enums.dart';

class CctvMaintProvider extends ChangeNotifier {
  CctvMaintProvider(this._cctvMaintService);
  final CCTVMaintService _cctvMaintService;

  // =======================================================
  // List VendorCheck

  // * state
  ViewState _state = ViewState.idle;
  ViewState get state => _state;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  // MainMaint list cache
  List<MainMaintMinResponse> _cctvCheckList = <MainMaintMinResponse>[];
  List<MainMaintMinResponse> get vendorCheckList {
    return UnmodifiableListView<MainMaintMinResponse>(_cctvCheckList);
  }

  // MainMaint list monthly cache
  List<MainMaintMinResponse> get cctvCheckListMonthly {
    return _cctvCheckList
        .where((MainMaintMinResponse element) => !element.quarterlyMode)
        .toList();
  }

  // MainMaint list monthly cache
  List<MainMaintMinResponse> get cctvCheckListQuarter {
    return _cctvCheckList
        .where((MainMaintMinResponse element) => element.quarterlyMode)
        .toList();
  }

  // *memasang filter pada pencarian Check
  FilterCheck _filterCctvCheck = FilterCheck(branch: App.getBranch());
  void setFilter(FilterCheck filter) {
    _filterCctvCheck = filter;
  }

  // * Mendapatkan vendorChecks
  Future<void> findCctvCheck() async {
    setState(ViewState.busy);

    String error = "";
    try {
      final MainMaintenanceListResponse response =
          await _cctvMaintService.findCctvMaintenance(_filterCctvCheck);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _cctvCheckList = response.data;
      }
    } catch (e) {
      error = e.toString();
    }

    setState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future<void>.error(error);
    }
  }

  // return future true jika add addCctvCheck berhasil
  // memanggil findCctvCheck sehigga tidak perlu notifyListener
  Future<bool> addCctvCheck(bool isQuartal, String name) async {
    setState(ViewState.busy);
    String error = "";

    try {
      final MessageResponse response =
          await _cctvMaintService.createCctvMaintenance(isQuartal, name);
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
    await findCctvCheck();
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

  String _idSaved = "";
  void setIDSaved(String cctvCheckID) {
    _idSaved = cctvCheckID;
  }

  // CctvCheck detail cache
  CCTVMaintDetailResponseData? _cctvCheckDetail;
  CCTVMaintDetailResponseData get cctvCheckDetail {
    if (_cctvCheckDetail == null) {
      return CCTVMaintDetailResponseData("", false, "", 0, "", "", 0, "", "",
          "", 0, 0, false, "", <CCTVMaintCheckItem>[]);
    }
    return _cctvCheckDetail!;
  }

  void removeDetail() {
    _cctvCheckDetail = null;
  }

  // get detail vendorVendorCheck
  // * Mendapatkan vendorVendorCheck
  Future<void> getDetail() async {
    setDetailState(ViewState.busy);

    String error = "";
    try {
      final CCTVMaintDetailResponse response =
          await _cctvMaintService.getCctvMaintenance(_idSaved);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _cctvCheckDetail = response.data;
      }
    } catch (e) {
      error = e.toString();
    }

    setDetailState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future<void>.error(error);
    }
  }

  // =============================
  // get distinct location
  List<String> getLocationList() {
    final List<CCTVMaintCheckItem> checkItems =
        _cctvCheckDetail?.cctvMaintCheckItems ?? <CCTVMaintCheckItem>[];
    final List<String> allLocation = <String>[];
    if (checkItems.isEmpty) {
      return <String>[];
    }
    for (final CCTVMaintCheckItem check in checkItems) {
      allLocation.add(check.location);
    }
    return allLocation.toSet().toList();
  }

  Map<String, List<CCTVMaintCheckItem>> getCheckItemPerLocation(
      List<String> locations) {
    final Map<String, List<CCTVMaintCheckItem>> checkMap =
        <String, List<CCTVMaintCheckItem>>{};
    if (_cctvCheckDetail == null) {
      return checkMap;
    }
    for (final String loc in locations) {
      checkMap[loc] = _cctvCheckDetail!.cctvMaintCheckItems
          .where((CCTVMaintCheckItem cctv) => cctv.location == loc)
          .toList();
    }
    return checkMap;
  }

  // =====================================================================
  // child cctvCheck

  ViewState _childState = ViewState.idle;
  ViewState get childState => _childState;
  void setChildState(ViewState viewState) {
    _childState = viewState;
    notifyListeners();
  }

// * update child
// return future true jika update updateChildCctvCheck berhasil
  Future<bool> updateChildCctvCheck(CCTVMaintUpdateRequest payload) async {
    setChildState(ViewState.busy);
    String error = "";

    try {
      final CCTVMaintDetailResponse response =
          await _cctvMaintService.updateCctvMaint(payload);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _cctvCheckDetail = response.data;
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
  // return future true jika completeCctvCheck berhasil
  // memanggil findCctvCheck sehigga tidak perlu notifyListener
  Future<bool> completeCctvCheck() async {
    setDetailState(ViewState.busy);
    String error = "";

    try {
      final CCTVMaintDetailResponse response =
          await _cctvMaintService.finishCctvMaintenance(_idSaved);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _cctvCheckDetail = response.data;
      }
    } catch (e) {
      error = e.toString();
    }

    setDetailState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future<bool>.error(error);
    }
    await findCctvCheck();
    return true;
  }

  // return future true jika delete deleteCctvCheck berhasil
  // memanggil findCctvCheck sehigga tidak perlu notifyListener
  Future<bool> deleteCctvCheck() async {
    setState(ViewState.busy);
    String error = "";

    try {
      final MessageResponse response =
          await _cctvMaintService.deleteCctvMaintenance(_idSaved);
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
    await findCctvCheck();
    return true;
  }

  // dipanggil ketika data sudah tidak dibutuhkan lagi,
  // di on dispose
  void onClose() {
    removeDetail();
    _cctvCheckList = <MainMaintMinResponse>[];
  }
}
