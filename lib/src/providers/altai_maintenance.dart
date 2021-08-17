import 'dart:collection';

import 'package:flutter/material.dart';

import '../api/filter_models/check_filter.dart';
import '../api/json_models/request/altai_maintenance_req.dart';
import '../api/json_models/response/altai_maintenance_resp.dart';
import '../api/json_models/response/main_maintenance_list_resp.dart';
import '../api/json_models/response/message_resp.dart';
import '../api/services/altai_maint_service.dart';
import '../globals.dart';
import '../utils/enums.dart';

class AltaiMaintProvider extends ChangeNotifier {
  AltaiMaintProvider(this._altaiMaintService);
  final AltaiMaintService _altaiMaintService;

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
  List<MainMaintMinResponse> _altaiCheckList = <MainMaintMinResponse>[];
  List<MainMaintMinResponse> get vendorCheckList {
    return UnmodifiableListView<MainMaintMinResponse>(_altaiCheckList);
  }

  // MainMaint list monthly cache
  List<MainMaintMinResponse> get altaiCheckListMonthly {
    return _altaiCheckList
        .where((MainMaintMinResponse element) => !element.quarterlyMode)
        .toList();
  }

  // MainMaint list monthly cache
  List<MainMaintMinResponse> get altaiCheckListQuarter {
    return _altaiCheckList
        .where((MainMaintMinResponse element) => element.quarterlyMode)
        .toList();
  }

  // *memasang filter pada pencarian Check
  FilterCheck _filterAltaiCheck = FilterCheck(branch: App.getBranch());
  void setFilter(FilterCheck filter) {
    _filterAltaiCheck = filter;
  }

  // * Mendapatkan vendorChecks
  Future<void> findAltaiCheck() async {
    setState(ViewState.busy);

    String error = "";
    try {
      final MainMaintenanceListResponse response =
          await _altaiMaintService.findAltaiMaintenance(_filterAltaiCheck);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _altaiCheckList = response.data;
      }
    } catch (e) {
      error = e.toString();
    }

    setState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future<void>.error(error);
    }
  }

  // return future true jika add addAltaiCheck berhasil
  // memanggil findAltaiCheck sehigga tidak perlu notifyListener
  Future<bool> addAltaiCheck(bool isQuartal, String name) async {
    setState(ViewState.busy);
    String error = "";

    try {
      final MessageResponse response = await _altaiMaintService
          .createAltaiMaintenance(isQuartal, name.toUpperCase());
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
    await findAltaiCheck();
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
  void setIDSaved(String altaiCheckID) {
    _idSaved = altaiCheckID;
  }

  // AltaiCheck detail cache
  AltaiMaintDetailResponseData? _altaiCheckDetail;
  AltaiMaintDetailResponseData get altaiCheckDetail {
    if (_altaiCheckDetail == null) {
      return AltaiMaintDetailResponseData("", false, "", 0, "", "", 0, "", "",
          "", 0, 0, false, "", <AltaiMaintCheckItem>[]);
    }
    return _altaiCheckDetail!;
  }

  void removeDetail() {
    _altaiCheckDetail = null;
  }

  // get detail vendorVendorCheck
  // * Mendapatkan vendorVendorCheck
  Future<void> getDetail() async {
    setDetailState(ViewState.busy);

    String error = "";
    try {
      final AltaiMaintDetailResponse response =
          await _altaiMaintService.getAltaiMaintenance(_idSaved);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _altaiCheckDetail = response.data;
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
    final List<AltaiMaintCheckItem> checkItems =
        _altaiCheckDetail?.altaiMaintCheckItems ?? <AltaiMaintCheckItem>[];
    final List<String> allLocation = <String>[];
    if (checkItems.isEmpty) {
      return <String>[];
    }
    for (final AltaiMaintCheckItem check in checkItems) {
      allLocation.add(check.location);
    }
    return allLocation.toSet().toList();
  }

  Map<String, List<AltaiMaintCheckItem>> getCheckItemPerLocation(
      List<String> locations) {
    final Map<String, List<AltaiMaintCheckItem>> checkMap =
        <String, List<AltaiMaintCheckItem>>{};
    if (_altaiCheckDetail == null) {
      return checkMap;
    }
    for (final String loc in locations) {
      checkMap[loc] = _altaiCheckDetail!.altaiMaintCheckItems
          .where((AltaiMaintCheckItem altai) => altai.location == loc)
          .toList();
    }
    return checkMap;
  }

  // =====================================================================
  // child altaiCheck

  ViewState _childState = ViewState.idle;
  ViewState get childState => _childState;
  void setChildState(ViewState viewState) {
    _childState = viewState;
    notifyListeners();
  }

// * update child
// return future true jika update updateChildAltaiCheck berhasil
  Future<bool> updateChildAltaiCheck(AltaiMaintUpdateRequest payload) async {
    setChildState(ViewState.busy);
    String error = "";

    try {
      final AltaiMaintDetailResponse response =
          await _altaiMaintService.updateAltaiMaint(payload);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _altaiCheckDetail = response.data;
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
  // return future true jika completeAltaiCheck berhasil
  // memanggil findAltaiCheck sehigga tidak perlu notifyListener
  Future<bool> completeAltaiCheck() async {
    setDetailState(ViewState.busy);
    String error = "";

    try {
      final AltaiMaintDetailResponse response =
          await _altaiMaintService.finishAltaiMaintenance(_idSaved);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _altaiCheckDetail = response.data;
      }
    } catch (e) {
      error = e.toString();
    }

    setDetailState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future<bool>.error(error);
    }
    await findAltaiCheck();
    return true;
  }

  // return future true jika delete deleteAltaiCheck berhasil
  // memanggil findAltaiCheck sehigga tidak perlu notifyListener
  Future<bool> deleteAltaiCheck() async {
    setState(ViewState.busy);
    String error = "";

    try {
      final MessageResponse response =
          await _altaiMaintService.deleteAltaiMaintenance(_idSaved);
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
    await findAltaiCheck();
    return true;
  }

  // dipanggil ketika data sudah tidak dibutuhkan lagi,
  // di on dispose
  void onClose() {
    removeDetail();
    _altaiCheckList = <MainMaintMinResponse>[];
  }
}
