import 'dart:collection';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:risa2/src/api/json_models/response/message_resp.dart';

import '../api/filter_models/computer_filter.dart';
import '../api/json_models/option/computer_option.dart';
import '../api/json_models/request/computer_edit_req.dart';
import '../api/json_models/request/computer_req.dart';
import '../api/json_models/response/computer_list_resp.dart';
import '../api/json_models/response/computer_resp.dart';
import '../api/json_models/response/general_list_resp.dart';
import '../api/services/computer_service.dart';
import '../globals.dart';
import '../utils/enums.dart';
import '../utils/image_compress.dart';

class ComputerProvider extends ChangeNotifier {
  ComputerProvider(this._computerService);
  final ComputerService _computerService;

  // =======================================================
  // List Computer

  // * state
  ViewState _state = ViewState.idle;
  ViewState get state => _state;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  // computer list cache
  List<ComputerMinResponse> _computerList = <ComputerMinResponse>[];
  List<ComputerMinResponse> get computerList {
    return UnmodifiableListView<ComputerMinResponse>(_computerList);
  }

  // computer extra list cache
  List<GeneralMinResponse> _computerExtraList = <GeneralMinResponse>[];
  List<GeneralMinResponse> get computerExtraList {
    return UnmodifiableListView<GeneralMinResponse>(_computerExtraList);
  }

  // *memasang filter pada pencarian computer
  FilterComputer _filterComputer = FilterComputer(
    branch: App.getBranch(),
  );
  void setFilter(FilterComputer filter) {
    _filterComputer = filter;
  }

  // * Mendapatkan computer
  Future<void> findComputer({bool loading = true}) async {
    if (loading) {
      setState(ViewState.busy);
    }

    String error = "";
    try {
      final ComputerListResponse response =
          await _computerService.findComputer(_filterComputer);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _computerList = response.data.computerList;
        _computerExtraList = response.data.extraList;
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
  // detail computer

  // * detail state
  ViewState _detailState = ViewState.idle;
  ViewState get detailState => _detailState;
  void setDetailState(ViewState viewState) {
    _detailState = viewState;
    notifyListeners();
  }

  String _computerIDSaved = "";
  void setComputerID(String computerID) {
    _computerIDSaved = computerID;
  }

  String getComputerId() => _computerIDSaved;

  // computer detail cache
  ComputerDetailResponseData _computerDetail = ComputerDetailResponseData(
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
      false,
      "",
      "",
      0,
      0,
      0,
      <String>[],
      "",
      "",
      "",
      "",
      ComputerExtra(<Case>[], 0, <PingState>[], ""));
  ComputerDetailResponseData get computerDetail {
    return _computerDetail;
  }

  void removeDetail() {
    _computerDetail = ComputerDetailResponseData(
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
        false,
        "",
        "",
        0,
        0,
        0,
        <String>[],
        "",
        "",
        "",
        "",
        ComputerExtra(<Case>[], 0, <PingState>[], ""));
  }

  // get detail computer
  // * Mendapatkan computer
  Future<void> getDetail() async {
    setDetailState(ViewState.busy);

    String error = "";
    try {
      final ComputerDetailResponse response =
          await _computerService.getComputer(_computerIDSaved);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        final ComputerDetailResponseData computerData = response.data!;
        _computerDetail = computerData;
      }
    } catch (e) {
      error = e.toString();
    }

    setDetailState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future<void>.error(error);
    }
  }

  // return future true jika add computer berhasil
  // memanggil findComputer sehingga tidak perlu notifyListener
  Future<bool> addComputer(ComputerRequest payload) async {
    setState(ViewState.busy);
    String error = "";

    try {
      final MessageResponse response =
          await _computerService.createComputer(payload);
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
    await findComputer(loading: false);
    return true;
  }

  // computer option cache
  OptComputerType _computerOption = OptComputerType(
    <String>["None"],
    <String>["None"],
    <String>["None"],
    <String>["None"],
    <int>[0],
    <int>[0],
    <String>["None"],
  );
  OptComputerType get computerOption {
    return _computerOption;
  }

  // * Mendapatkan check option
  Future<void> findOptionComputer() async {
    try {
      final OptComputerType response =
          await _computerService.getOptCreateComputer(App.getBranch() ?? "");
      _computerOption = response;
    } catch (e) {
      return Future<void>.error(e.toString());
    }
    notifyListeners();
  }

  // return future ComputerDetail jika edit computer berhasil
  Future<bool> editComputer(ComputerEditRequest payload) async {
    setState(ViewState.busy);
    String error = "";

    try {
      final ComputerDetailResponse response =
          await _computerService.editComputer(_computerIDSaved, payload);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _computerDetail = response.data!;
      }
    } catch (e) {
      error = e.toString();
    }

    setState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future<bool>.error(error);
    }

    await findComputer(loading: false);
    return true;
  }

  // * update image
  // return future true jika update image berhasil
  Future<bool> uploadImage(String id, File file) async {
    String error = "";

    final File fileCompressed = await compressFile(file);

    try {
      final ComputerDetailResponse response =
          await _computerService.uploadImage(id, fileCompressed);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _computerDetail = response.data!;
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

  // remove computer
  Future<bool> removeComputer() async {
    String error = "";

    try {
      final MessageResponse response =
          await _computerService.deleteComputer(_computerIDSaved);
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
    await findComputer(loading: false);
    return true;
  }

  // * detail state
  ViewState _computerChangeState = ViewState.idle;
  ViewState get computerChangeState => _computerChangeState;
  void setComputerChangeState(ViewState viewState) {
    _computerChangeState = viewState;
    notifyListeners();
  }

  // dipanggil ketika data sudah tidak dibutuhkan lagi,
  // di on dispose
  void onClose() {
    removeDetail();
    _computerExtraList = <GeneralMinResponse>[];
    _computerList = <ComputerMinResponse>[];
  }
}
