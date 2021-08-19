import 'dart:collection';

import 'package:flutter/material.dart';

import '../api/filter_models/check_filter.dart';
import '../api/json_models/request/altai_virtual_req.dart';
import '../api/json_models/response/altai_virtual_list_resp.dart';
import '../api/json_models/response/altai_virtual_resp.dart';
import '../api/json_models/response/message_resp.dart';
import '../api/services/altai_virtual_service.dart';
import '../globals.dart';
import '../utils/enums.dart';

class AltaiVirtualProvider extends ChangeNotifier {
  AltaiVirtualProvider(this._altaiVirtualService);
  final AltaiVirtualService _altaiVirtualService;

  // =======================================================
  // List AltaiVirtual

  // * state
  ViewState _state = ViewState.idle;
  ViewState get state => _state;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  // altaiVirtual list cache
  List<AltaiVirtualMinResponse> _altaiVirtualList = <AltaiVirtualMinResponse>[];
  List<AltaiVirtualMinResponse> get altaiVirtualList {
    return UnmodifiableListView<AltaiVirtualMinResponse>(_altaiVirtualList);
  }

  // *memasang filter pada pencarian altaiVirtual
  FilterCheck _filterAltaiVirtual = FilterCheck(branch: App.getBranch());
  void setFilter(FilterCheck filter) {
    _filterAltaiVirtual = filter;
  }

  // * Mendapatkan altaiVirtuals
  Future<void> findAltaiVirtual() async {
    setState(ViewState.busy);

    String error = "";
    try {
      final AltaiVirtualListResponse response =
          await _altaiVirtualService.findAltaiVirtual(_filterAltaiVirtual);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _altaiVirtualList = response.data;
      }
    } catch (e) {
      error = e.toString();
    }

    setState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future<void>.error(error);
    }
  }

  // return future true jika add altaiAltaiVirtual berhasil
  // memanggil findAltaiVirtual sehigga tidak perlu notifyListener
  Future<bool> addAltaiVirtual() async {
    setState(ViewState.busy);
    String error = "";

    try {
      final MessageResponse response =
          await _altaiVirtualService.createAltaiVirtual();
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
    await findAltaiVirtual();
    return true;
  }

  // ========================================================
  // detail altaiAltaiVirtual

  // * detail state
  ViewState _detailState = ViewState.idle;
  ViewState get detailState => _detailState;
  void setDetailState(ViewState viewState) {
    _detailState = viewState;
    notifyListeners();
  }

  String _altaiVirtualIDSaved = "";
  void setAltaiVirtualID(String altaiVirtualID) {
    _altaiVirtualIDSaved = altaiVirtualID;
  }

  // altaiAltaiVirtual detail cache
  AltaiVirtualDetailResponseData? _altaiVirtualDetail;
  AltaiVirtualDetailResponseData get altaiVirtualDetail {
    if (_altaiVirtualDetail == null) {
      return AltaiVirtualDetailResponseData(
          "", 0, "", "", 0, "", "", "", 0, 0, false, "", <AltaiCheckItem>[]);
    }
    return _altaiVirtualDetail!;
  }

  void removeDetail() {
    _altaiVirtualDetail = null;
  }

  // get detail altaiAltaiVirtual
  // * Mendapatkan altaiAltaiVirtual
  Future<void> getDetail() async {
    setDetailState(ViewState.busy);

    String error = "";
    try {
      final AltaiVirtualDetailResponse response =
          await _altaiVirtualService.getAltaiVirtual(_altaiVirtualIDSaved);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _altaiVirtualDetail = response.data;
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
    final List<AltaiCheckItem> checkItems =
        _altaiVirtualDetail?.altaiCheckItems ?? <AltaiCheckItem>[];
    final List<String> allLocation = <String>[];
    if (checkItems.isEmpty) {
      return <String>[];
    }
    for (final AltaiCheckItem check in checkItems) {
      allLocation.add(check.location);
    }
    return allLocation.toSet().toList();
  }

  Map<String, List<AltaiCheckItem>> getCheckItemPerLocation(
      List<String> locations) {
    final Map<String, List<AltaiCheckItem>> checkMap =
        <String, List<AltaiCheckItem>>{};
    if (_altaiVirtualDetail == null) {
      return checkMap;
    }
    for (final String loc in locations) {
      checkMap[loc] = _altaiVirtualDetail!.altaiCheckItems
          .where((AltaiCheckItem altai) => altai.location == loc)
          .toList();
    }
    return checkMap;
  }

  // =====================================================================
  // child altaiAltaiVirtual

  ViewState _childState = ViewState.idle;
  ViewState get childState => _childState;
  void setChildState(ViewState viewState) {
    _childState = viewState;
    notifyListeners();
  }

// * update child
// return future true jika update altaiAltaiVirtual berhasil
  Future<bool> updateChildAltaiVirtual(
      AltaiVirtualUpdateRequest payload) async {
    setChildState(ViewState.busy);
    String error = "";

    try {
      final AltaiVirtualDetailResponse response =
          await _altaiVirtualService.updateAltaiVirtual(payload);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _altaiVirtualDetail = response.data;
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
  // return future true jika completeAltaiVirtual berhasil
  // memanggil findAltaiVirtual sehigga tidak perlu notifyListener
  Future<bool> completeAltaiVirtual() async {
    setDetailState(ViewState.busy);
    String error = "";

    try {
      final AltaiVirtualDetailResponse response =
          await _altaiVirtualService.finishAltaiVirtual(_altaiVirtualIDSaved);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _altaiVirtualDetail = response.data;
      }
    } catch (e) {
      error = e.toString();
    }

    setDetailState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future<bool>.error(error);
    }
    await findAltaiVirtual();
    return true;
  }

  // return future true jika delete altaiAltaiVirtual berhasil
  // memanggil findAltaiVirtual sehigga tidak perlu notifyListener
  Future<bool> deleteAltaiVirtual() async {
    setState(ViewState.busy);
    String error = "";

    try {
      final MessageResponse response =
          await _altaiVirtualService.deleteAltaiVirtual(_altaiVirtualIDSaved);
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
    await findAltaiVirtual();
    return true;
  }

  // dipanggil ketika data sudah tidak dibutuhkan lagi,
  // di on dispose
  void onClose() {
    removeDetail();
    _altaiVirtualList = <AltaiVirtualMinResponse>[];
  }
}
