import 'dart:collection';
import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../api/filter_models/other_filter.dart';
import '../api/json_models/option/location_division.dart';
import '../api/json_models/request/other_edit_req.dart';
import '../api/json_models/request/other_req.dart';
import '../api/json_models/response/general_list_resp.dart';
import '../api/json_models/response/message_resp.dart';
import '../api/json_models/response/other_list_resp.dart';
import '../api/json_models/response/other_resp.dart';
import '../api/services/other_service.dart';
import '../globals.dart';
import '../utils/enums.dart';
import '../utils/image_compress.dart';

class OtherProvider extends ChangeNotifier {
  OtherProvider(this._otherService);
  final OtherService _otherService;

  // =======================================================
  String _subCategory = "";
  void setSubCategory(String value) {
    _subCategory = value;
  }

  String get subCategory => _subCategory;

  // =======================================================
  // List Other

  // * state
  ViewState _state = ViewState.idle;
  ViewState get state => _state;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  // other list cache
  List<OtherMinResponse> _otherList = <OtherMinResponse>[];
  List<OtherMinResponse> get otherList {
    return UnmodifiableListView<OtherMinResponse>(_otherList);
  }

  // other extra list cache
  List<GeneralMinResponse> _otherExtraList = [];
  List<GeneralMinResponse> get otherExtraList {
    return UnmodifiableListView<GeneralMinResponse>(_otherExtraList);
  }

  // *memasang filter pada pencarian other
  FilterOther _filterOther = FilterOther(
    branch: App.getBranch(),
  );
  void setFilter(FilterOther filter) {
    _filterOther = filter;
  }

  // * Mendapatkan other
  Future<void> findOther({bool loading = true}) async {
    if (loading) {
      setState(ViewState.busy);
    }

    String error = "";
    try {
      final OtherListResponse response =
          await _otherService.findOther(_filterOther, _subCategory);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _otherList = response.data.otherList;
        _otherExtraList = response.data.extraList;
      }
    } catch (e) {
      error = e.toString();
    }

    setState(ViewState.idle);

    if (error.isNotEmpty) {
      return Future<void>.error(error);
    }
  }

// ========================================================
  // detail other

  // * detail state
  ViewState _detailState = ViewState.idle;
  ViewState get detailState => _detailState;
  void setDetailState(ViewState viewState) {
    _detailState = viewState;
    notifyListeners();
  }

  String _otherIDSaved = "";
  void setOtherID(String otherID) {
    _otherIDSaved = otherID;
  }

  String getOtherId() => _otherIDSaved;

  // other detail cache
  OtherDetailResponseData _otherDetail = OtherDetailResponseData(
      "",
      "",
      0,
      0,
      "",
      "",
      "",
      "",
      "",
      false,
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      0,
      <String>[],
      "",
      "",
      "",
      "",
      OtherExtra(<Case>[], 0, <PingState>[], ""));
  OtherDetailResponseData get otherDetail {
    return _otherDetail;
  }

  void removeDetail() {
    _otherDetail = OtherDetailResponseData(
        "",
        "",
        0,
        0,
        "",
        "",
        "",
        "",
        "",
        false,
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        0,
        <String>[],
        "",
        "",
        "",
        "",
        OtherExtra(<Case>[], 0, <PingState>[], ""));
  }

  // get detail other
  // * Mendapatkan other
  Future<void> getDetail() async {
    setDetailState(ViewState.busy);

    String error = "";
    try {
      final OtherDetailResponse response =
          await _otherService.getOther(_otherIDSaved);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        final OtherDetailResponseData otherData = response.data!;
        _otherDetail = otherData;
      }
    } catch (e) {
      error = e.toString();
    }

    setDetailState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future<void>.error(error);
    }
  }

  // return future true jika add other berhasil
  // memanggil findOther sehingga tidak perlu notifyListener
  Future<bool> addOther(OtherRequest payload) async {
    setState(ViewState.busy);
    String error = "";

    try {
      final MessageResponse response = await _otherService.createOther(payload);
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
    await findOther(loading: false);
    return true;
  }

  // other option cache
  OptLocationDivison _otherOption =
      OptLocationDivison(<String>["None"], <String>["None"]);
  OptLocationDivison get otherOption {
    return _otherOption;
  }

  // * Mendapatkan check option
  Future<void> findOptionOther() async {
    try {
      final OptLocationDivison response =
          await _otherService.getOptCreateOther(App.getBranch() ?? "");
      _otherOption = response;
    } catch (e) {
      return Future<void>.error(e.toString());
    }
    notifyListeners();
  }

  // return future OtherDetail jika edit other berhasil
  Future<bool> editOther(OtherEditRequest payload) async {
    setState(ViewState.busy);
    String error = "";

    try {
      final OtherDetailResponse response =
          await _otherService.editOther(_otherIDSaved, payload);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _otherDetail = response.data!;
      }
    } catch (e) {
      error = e.toString();
    }

    setState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future<bool>.error(error);
    }

    await findOther(loading: false);
    return true;
  }

  // * update image
  // return future true jika update image berhasil
  Future<bool> uploadImage(String id, File file) async {
    String error = "";

    final File fileCompressed = await compressFile(file);

    try {
      final OtherDetailResponse response =
          await _otherService.uploadImage(id, fileCompressed);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _otherDetail = response.data!;
      }
    } catch (e) {
      error = e.toString();
    }

    notifyListeners();

    if (error.isNotEmpty) {
      return Future<bool>.error(error);
    }
    return true;
  }

  // remove other
  Future<bool> removeOther() async {
    String error = "";

    try {
      final MessageResponse response =
          await _otherService.deleteOther(_otherIDSaved, _subCategory);
      if (response.error != null) {
        error = response.error!.message;
      }
    } catch (e) {
      error = e.toString();
    }

    notifyListeners();
    if (error.isNotEmpty) {
      return Future<bool>.error(error);
    }
    await findOther(loading: false);
    return true;
  }

  // * detail state
  ViewState _otherChangeState = ViewState.idle;
  ViewState get otherChangeState => _otherChangeState;
  void setOtherChangeState(ViewState viewState) {
    _otherChangeState = viewState;
    notifyListeners();
  }

  // dipanggil ketika data sudah tidak dibutuhkan lagi,
  // di on dispose
  void onClose() {
    removeDetail();
    // _otherExtraList = [];
    _otherList = <OtherMinResponse>[];
  }
}
