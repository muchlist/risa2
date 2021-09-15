import 'dart:collection';

import 'package:flutter/material.dart';

import '../api/filter_models/check_filter.dart';
import '../api/json_models/request/config_check_req.dart';
import '../api/json_models/response/config_check_list_resp.dart';
import '../api/json_models/response/config_check_resp.dart';
import '../api/json_models/response/message_resp.dart';
import '../api/services/config_check_service.dart';
import '../globals.dart';
import '../utils/enums.dart';

class ConfigCheckProvider extends ChangeNotifier {
  ConfigCheckProvider(this._configItemService);
  final ConfigCheckService _configItemService;

  // =======================================================
  // List ConfigCheck

  // * state
  ViewState _state = ViewState.idle;
  ViewState get state => _state;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  // configCheckItem list cache
  List<ConfigCheckItem> _configItemList = <ConfigCheckItem>[];
  List<ConfigCheckItem> get configItemList {
    return UnmodifiableListView<ConfigCheckItem>(_configItemList);
  }

  // *memasang filter pada pencarian configItem
  FilterCheck _filterConfigCheck = FilterCheck(branch: App.getBranch());
  void setFilter(FilterCheck filter) {
    _filterConfigCheck = filter;
  }

  // * Mendapatkan configCheck dari api
  Future<void> findConfigCheck() async {
    setState(ViewState.busy);

    String error = "";
    try {
      final ConfigCheckListResponse response =
          await _configItemService.findConfigCheck(_filterConfigCheck);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _configItemList = response.data;
      }
    } catch (e) {
      error = e.toString();
    }

    setState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future<void>.error(error);
    }
  }

  // return future true jika add configCheck berhasil
  // memanggil findConfigCheck sehigga tidak perlu notifyListener
  Future<bool> addConfigCheck() async {
    setState(ViewState.busy);
    String error = "";

    try {
      final MessageResponse response =
          await _configItemService.createConfigCheck();
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
    await findConfigCheck();
    return true;
  }

  // ========================================================
  // detail configConfigCheck

  // * detail state
  ViewState _detailState = ViewState.idle;
  ViewState get detailState => _detailState;
  void setDetailState(ViewState viewState) {
    _detailState = viewState;
    notifyListeners();
  }

  String _idSaved = "";
  void setConfigCheckID(String configID) {
    _idSaved = configID;
  }

  // configConfigCheck detail cache
  ConfigCheckDetailResponseData? _configDetail;
  ConfigCheckDetailResponseData get configItemDetail {
    if (_configDetail == null) {
      return ConfigCheckDetailResponseData(
          "", 0, "", "", 0, "", "", "", 0, 0, false, "", <ConfigCheckItem>[]);
    }
    return _configDetail!;
  }

  void removeDetail() {
    _configDetail = null;
  }

  // get detail configConfigCheck
  // * Mendapatkan detail configCheck
  Future<void> getDetail() async {
    setDetailState(ViewState.busy);

    String error = "";
    try {
      final ConfigCheckDetailResponse response =
          await _configItemService.getConfigCheck(_idSaved);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _configDetail = response.data;
      }
    } catch (e) {
      error = e.toString();
    }

    setDetailState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future<void>.error(error);
    }
  }

  // * berpotensi bug ketika  menambahkan list didalam map
  Map<String, List<ConfigCheckItem>> getCheckItemSeparatedByLetter() {
    final Map<String, List<ConfigCheckItem>> checkMap =
        <String, List<ConfigCheckItem>>{};
    if (_configDetail == null) {
      return checkMap;
    }

    final List<ConfigCheckItem> configCheckItems =
        _configDetail!.configCheckItems;

    if (configCheckItems.isEmpty) {
      return checkMap;
    }

    for (final ConfigCheckItem item in configCheckItems) {
      final String letter = item.name.toUpperCase()[0];
      if (checkMap.containsKey(letter)) {
        checkMap[letter]!.add(item);
      } else {
        final List<ConfigCheckItem> newListItem = <ConfigCheckItem>[];
        newListItem.add(item);
        checkMap[letter] = newListItem;
      }
    }
    return checkMap;
  }

  ViewState _childState = ViewState.idle;
  ViewState get childState => _childState;
  void setChildState(ViewState viewState) {
    _childState = viewState;
    notifyListeners();
  }

// * update child
// return future true jika update configConfigCheck berhasil
  Future<bool> updateChildConfigCheck(ConfigCheckUpdateRequest payload) async {
    setChildState(ViewState.busy);
    String error = "";

    try {
      final ConfigCheckDetailResponse response =
          await _configItemService.updateConfigCheck(payload);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _configDetail = response.data;
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
  // return future true jika completeConfigCheck berhasil
  // memanggil findConfigCheck sehigga tidak perlu notifyListener
  Future<bool> completeConfigCheck() async {
    setDetailState(ViewState.busy);
    String error = "";

    try {
      final ConfigCheckDetailResponse response =
          await _configItemService.finishConfigCheck(_idSaved);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _configDetail = response.data;
      }
    } catch (e) {
      error = e.toString();
    }

    setDetailState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future<bool>.error(error);
    }
    await findConfigCheck();
    return true;
  }

  // return future true jika delete configConfigCheck berhasil
  // memanggil findConfigCheck sehigga tidak perlu notifyListener
  Future<bool> deleteConfigCheck() async {
    setState(ViewState.busy);
    String error = "";

    try {
      final MessageResponse response =
          await _configItemService.deleteConfigCheck(_idSaved);
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
    await findConfigCheck();
    return true;
  }

  // dipanggil ketika data sudah tidak dibutuhkan lagi,
  // di on dispose
  void onClose() {
    removeDetail();
    _configItemList = <ConfigCheckItem>[];
  }
}
