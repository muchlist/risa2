import 'dart:collection';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:risa2/src/api/json_models/option/location_type.dart';
import 'package:risa2/src/api/json_models/request/cctv_edit_req.dart';
import 'package:risa2/src/utils/image_compress.dart';

import '../api/filter_models/cctv_filter.dart';
import '../api/json_models/request/cctv_req.dart';
import '../api/json_models/response/cctv_list_resp.dart';
import '../api/json_models/response/cctv_resp.dart';
import '../api/services/cctv_service.dart';
import '../globals.dart';
import '../utils/enums.dart';

class CctvProvider extends ChangeNotifier {
  final CctvService _cctvService;
  CctvProvider(this._cctvService);

  // =======================================================
  // List Cctv

  // * state
  ViewState _state = ViewState.idle;
  ViewState get state => _state;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  // cctv list cache
  List<CctvMinResponse> _cctvList = [];
  List<CctvMinResponse> get cctvList {
    return UnmodifiableListView(_cctvList);
  }

  // *memasang filter pada pencarian cctv
  FilterCctv _filterCctv = FilterCctv(
    branch: App.getBranch(),
  );
  void setFilter(FilterCctv filter) {
    _filterCctv = filter;
  }

  // * Mendapatkan cctv
  Future<void> findCctv({bool loading = true}) async {
    if (loading) {
      setState(ViewState.busy);
    }

    var error = "";
    try {
      final response = await _cctvService.findCctv(_filterCctv);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _cctvList = response.data;
      }
    } catch (e) {
      error = e.toString();
    }

    setState(ViewState.idle);

    if (error.isNotEmpty) {
      return Future.error(error);
    }
  }

// ========================================================
  // detail cctv

  // * detail state
  ViewState _detailState = ViewState.idle;
  ViewState get detailState => _detailState;
  void setDetailState(ViewState viewState) {
    _detailState = viewState;
    notifyListeners();
  }

  String _cctvIDSaved = "";
  void setCctvID(String cctvID) {
    _cctvIDSaved = cctvID;
  }

  // cctv detail cache
  CctvDetailResponseData _cctvDetail = CctvDetailResponseData("", 0, 0, "", "",
      "", "", "", false, "", "", "", "", "", "", 0, [], "", "", "", "");
  CctvDetailResponseData get cctvDetail {
    return _cctvDetail;
  }

  void removeDetail() {
    _cctvDetail = CctvDetailResponseData("", 0, 0, "", "", "", "", "", false,
        "", "", "", "", "", "", 0, [], "", "", "", "");
  }

  // get detail cctv
  // * Mendapatkan cctv
  Future<void> getDetail() async {
    setDetailState(ViewState.busy);

    var error = "";
    try {
      final response = await _cctvService.getCctv(_cctvIDSaved);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        final cctvData = response.data!;
        _cctvDetail = cctvData;
      }
    } catch (e) {
      error = e.toString();
    }

    setDetailState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future.error(error);
    }
  }

  // return future true jika add cctv berhasil
  // memanggil findCctv sehingga tidak perlu notifyListener
  Future<bool> addCctv(CctvRequest payload) async {
    setState(ViewState.busy);
    var error = "";

    try {
      final response = await _cctvService.createCctv(payload);
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
    await findCctv(loading: false);
    return true;
  }

  // cctv option cache
  OptLocationType _cctvOption = OptLocationType(["None"], ["None"]);
  OptLocationType get cctvOption {
    return _cctvOption;
  }

  // * Mendapatkan check option
  Future<void> findOptionCctv() async {
    try {
      final response =
          await _cctvService.getOptCreateCctv(App.getBranch() ?? "");
      _cctvOption = response;
    } catch (e) {
      return Future.error(e.toString());
    }
    notifyListeners();
  }

  // return future CctvDetail jika edit cctv berhasil
  Future<bool> editCctv(CctvEditRequest payload) async {
    setState(ViewState.busy);
    var error = "";

    try {
      final response = await _cctvService.editCctv(_cctvIDSaved, payload);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _cctvDetail = response.data!;
      }
    } catch (e) {
      error = e.toString();
    }

    setState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future.error(error);
    }

    await findCctv(loading: false);
    return true;
  }

  // * update image
  // return future true jika update image berhasil
  Future<bool> uploadImage(String id, File file) async {
    var error = "";

    final fileCompressed = await compressFile(file);

    try {
      final response = await _cctvService.uploadImage(id, fileCompressed);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _cctvDetail = response.data!;
      }
    } catch (e) {
      error = e.toString();
    }

    notifyListeners();

    if (error.isNotEmpty) {
      return Future.error(error);
    }
    return true;
  }

  // remove cctv
  Future<bool> removeCctv() async {
    var error = "";

    try {
      final response = await _cctvService.deleteCctv(_cctvIDSaved);
      if (response.error != null) {
        error = response.error!.message;
      }
    } catch (e) {
      error = e.toString();
    }

    notifyListeners();
    if (error.isNotEmpty) {
      return Future.error(error);
    }
    await findCctv(loading: false);
    return true;
  }

  // * detail state
  ViewState _cctvChangeState = ViewState.idle;
  ViewState get cctvChangeState => _cctvChangeState;
  void setCctvChangeState(ViewState viewState) {
    _cctvChangeState = viewState;
    notifyListeners();
  }
}
