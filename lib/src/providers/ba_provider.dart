import 'dart:collection';
import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../api/filter_models/ba_filter.dart';
import '../api/json_models/request/ba_add_participant_req.dart';
import '../api/json_models/request/ba_edit_req.dart';
import '../api/json_models/request/ba_req.dart';
import '../api/json_models/response/ba_list_resp.dart';
import '../api/json_models/response/ba_resp.dart';
import '../api/json_models/response/general_list_resp.dart';
import '../api/json_models/response/message_resp.dart';
import '../api/services/ba_service.dart';
import '../globals.dart';
import '../utils/enums.dart';
import '../utils/image_compress.dart';

class BaProvider extends ChangeNotifier {
  BaProvider(this._baService);
  final BaService _baService;

  // =======================================================
  // List Ba

  // * state
  ViewState _state = ViewState.idle;
  ViewState get state => _state;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  // ba list cache
  List<BaMinResponse> _baList = <BaMinResponse>[];
  List<BaMinResponse> get baList {
    return UnmodifiableListView<BaMinResponse>(_baList);
  }

  // ba extra list cache
  List<GeneralMinResponse> _baExtraList = <GeneralMinResponse>[];
  List<GeneralMinResponse> get baExtraList {
    return UnmodifiableListView<GeneralMinResponse>(_baExtraList);
  }

  // *memasang filter pada pencarian ba
  FilterBa _filterBa = FilterBa(
    branch: App.getBranch(),
  );
  void setFilter(FilterBa filter) {
    _filterBa = filter;
  }

  // * Mendapatkan ba
  Future<void> findBa({bool loading = true}) async {
    if (loading) {
      setState(ViewState.busy);
    }

    String error = "";
    try {
      final BaListResponse response = await _baService.findBa(_filterBa);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _baList = response.data;
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
  // detail ba

  // * detail state
  ViewState _detailState = ViewState.idle;
  ViewState get detailState => _detailState;
  void setDetailState(ViewState viewState) {
    _detailState = viewState;
    notifyListeners();
  }

  String _baIDSaved = "";
  void setBaID(String baID) {
    _baIDSaved = baID;
  }

  String getBaId() => _baIDSaved;

  // ba detail cache
  BaDetailResponseData _baDetail = BaDetailResponseData(
      "",
      0,
      "",
      "",
      0,
      "",
      "",
      "",
      "",
      "",
      0,
      <Participant>[],
      <Participant>[],
      0,
      "",
      <String>[],
      "",
      <Description>[],
      <Equipment>[]);

  BaDetailResponseData get baDetail {
    return _baDetail;
  }

  void removeDetail() {
    _baDetail = BaDetailResponseData(
        "",
        0,
        "",
        "",
        0,
        "",
        "",
        "",
        "",
        "",
        0,
        <Participant>[],
        <Participant>[],
        0,
        "",
        <String>[],
        "",
        <Description>[],
        <Equipment>[]);
  }

  // get detail ba
  // * Mendapatkan ba
  Future<void> getDetail({bool loading = true}) async {
    if (loading) {
      setDetailState(ViewState.busy);
    }

    String error = "";
    try {
      final BaDetailResponse response = await _baService.getBa(_baIDSaved);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        final BaDetailResponseData baData = response.data!;
        _baDetail = baData;
      }
    } catch (e) {
      error = e.toString();
    }

    setDetailState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future<void>.error(error);
    }
  }

  // return future true jika add ba berhasil
  // memanggil findBa sehingga tidak perlu notifyListener
  Future<bool> addBa(BaRequest payload) async {
    setState(ViewState.busy);
    String error = "";

    try {
      final MessageResponse response =
          await _baService.createBaTempOne(payload);
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
    await findBa(loading: false);
    return true;
  }

  // return future BaDetail jika edit ba berhasil
  Future<bool> editBa(BaEditRequest payload) async {
    setDetailState(ViewState.busy);
    String error = "";

    try {
      final BaDetailResponse response =
          await _baService.editBa(_baIDSaved, payload);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _baDetail = response.data!;
      }
    } catch (e) {
      error = e.toString();
    }

    setDetailState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future<bool>.error(error);
    }

    await findBa(loading: false);
    return true;
  }

  // return future true jika toSignMode ba berhasil
  Future<bool> toSignMode() async {
    setDetailState(ViewState.busy);
    String error = "";

    try {
      final BaDetailResponse response = await _baService.toSignMode(_baIDSaved);

      if (response.error != null) {
        error = response.error!.message;
      } else {
        _baDetail = response.data!;
      }
    } catch (e) {
      error = e.toString();
    }

    setDetailState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future<bool>.error(error);
    }

    return true;
  }

  // return future true jika toDraftMode ba berhasil
  Future<bool> toDraftMode() async {
    setDetailState(ViewState.busy);
    String error = "";

    try {
      final BaDetailResponse response =
          await _baService.toDraftMode(_baIDSaved);

      if (response.error != null) {
        error = response.error!.message;
      } else {
        _baDetail = response.data!;
      }
    } catch (e) {
      error = e.toString();
    }

    setDetailState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future<bool>.error(error);
    }

    return true;
  }

  // return future BaDetail jika addApprover ba berhasil
  Future<bool> addParty(
      BaAddParticipantRequest payload, enumTypeParty typeParty) async {
    setDetailState(ViewState.busy);
    String error = "";

    try {
      BaDetailResponse response;
      if (typeParty == enumTypeParty.approver) {
        response = await _baService.addApprover(_baIDSaved, payload);
      } else {
        response = await _baService.addParticipant(_baIDSaved, payload);
      }

      if (response.error != null) {
        error = response.error!.message;
      } else {
        _baDetail = response.data!;
      }
    } catch (e) {
      error = e.toString();
    }

    setDetailState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future<bool>.error(error);
    }

    return true;
  }

  // return future BaDetail jika addApprover ba berhasil
  Future<bool> removeParty(String userID, enumTypeParty typeParty) async {
    setDetailState(ViewState.busy);
    String error = "";

    try {
      BaDetailResponse response;
      if (typeParty == enumTypeParty.approver) {
        response = await _baService.removeApprover(_baIDSaved, userID);
      } else {
        response = await _baService.removeParticipant(_baIDSaved, userID);
      }

      if (response.error != null) {
        error = response.error!.message;
      } else {
        _baDetail = response.data!;
      }
    } catch (e) {
      error = e.toString();
    }

    setDetailState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future<bool>.error(error);
    }

    return true;
  }

  // * upload image
  // return future true jika update image berhasil
  Future<bool> uploadImage(String id, File file) async {
    String error = "";

    try {
      final BaDetailResponse response = await _baService.uploadImage(id, file);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _baDetail = response.data!;
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

  // return future BaDetail jika addApprover ba berhasil
  Future<bool> removeImage(String imagepath) async {
    setDetailState(ViewState.busy);
    String error = "";

    try {
      final BaDetailResponse response =
          await _baService.deleteImage(_baIDSaved, imagepath);

      if (response.error != null) {
        error = response.error!.message;
      } else {
        _baDetail = response.data!;
      }
    } catch (e) {
      error = e.toString();
    }

    setDetailState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future<bool>.error(error);
    }

    return true;
  }

  // * sign upload image
  // return future true jika update image berhasil
  Future<bool> signWithImage(String id, File file) async {
    String error = "";

    final File fileCompressed = await compressFile(file);

    try {
      final BaDetailResponse response =
          await _baService.sign(id, fileCompressed);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _baDetail = response.data!;
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

  // * detail state
  ViewState _baChangeState = ViewState.idle;
  ViewState get baChangeState => _baChangeState;
  void setBaChangeState(ViewState viewState) {
    _baChangeState = viewState;
    notifyListeners();
  }

  // dipanggil ketika data sudah tidak dibutuhkan lagi,
  // di on dispose
  void onClose() {
    removeDetail();
    _baExtraList = <GeneralMinResponse>[];
    _baList = <BaMinResponse>[];
  }
}
