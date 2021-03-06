import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:risa2/src/api/json_models/response/message_resp.dart';

import '../api/filter_models/improve_filter.dart';
import '../api/json_models/request/improve_change_req.dart';
import '../api/json_models/request/improve_edit_req.dart';
import '../api/json_models/request/improve_req.dart';
import '../api/json_models/response/improve_list_resp.dart';
import '../api/json_models/response/improve_resp.dart';
import '../api/services/improve_service.dart';
import '../globals.dart';
import '../utils/enums.dart';

class ImproveProvider extends ChangeNotifier {
  ImproveProvider(this._improveService);
  final ImproveService _improveService;

  ViewState _state = ViewState.idle;

  ViewState get state => _state;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  List<ImproveMinResponse> _improveList = <ImproveMinResponse>[
    ImproveMinResponse(
        "", 0, 0, "", "Loading ...", "Loading, please standby!", 0, 0, true, 1)
  ];

  List<ImproveMinResponse> get improveList {
    return UnmodifiableListView<ImproveMinResponse>(_improveList);
  }

  List<ImproveMinResponse> get improveListFront {
    return UnmodifiableListView<ImproveMinResponse>(_improveList.where(
        (ImproveMinResponse el) => el.isActive && el.completeStatus != 2));
  }

  Future<void> findImprove({bool loading = true}) async {
    if (loading) {
      setState(ViewState.busy);
    }

    final FilterImporve filter =
        FilterImporve(branch: App.getBranch(), limit: 10);
    String error = "";

    try {
      final ImproveListResponse response =
          await _improveService.findImprove(filter);
      if (response.error != null) {
        _improveList = <ImproveMinResponse>[
          ImproveMinResponse(
              "", 0, 0, "", "Error ...", response.error!.message, 0, 0, true, 1)
        ];
        error = response.error!.message;
      } else {
        _improveList = response.data;
      }
    } catch (e) {
      _improveList = <ImproveMinResponse>[
        ImproveMinResponse(
            "", 0, 0, "", "Error ...", error.toString(), 0, 0, true, 1)
      ];
      error = e.toString();
    }

    setState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future<void>.error(error);
    }
  }

  // Detail Improvement ========================================
  ViewState _detailState = ViewState.idle;
  ViewState get detailState => _detailState;
  void setDetailState(ViewState viewState) {
    _detailState = viewState;
    notifyListeners();
  }

  String _detailIDSaved = "";
  String get detailID => _detailIDSaved;
  void setDetailID(String id) {
    _detailIDSaved = id;
  }

  // improve detail cache
  ImproveDetailResponseData _improveDetail = ImproveDetailResponseData(
      "", 0, 0, "", "", "", "", "", "", "", 0, 0, false, 0, <ImproveChange>[]);
  ImproveDetailResponseData get improveDetail {
    return _improveDetail;
  }

  // get detail improve
  // * Mendapatkan improve
  Future<void> getDetail() async {
    setDetailState(ViewState.busy);

    String error = "";
    try {
      final ImproveDetailResponse response =
          await _improveService.getImprove(_detailIDSaved);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _improveDetail = response.data!;
      }
    } catch (e) {
      error = e.toString();
    }

    setDetailState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future<void>.error(error);
    }
  }

  void removeDetail() {
    _improveDetail = ImproveDetailResponseData("", 0, 0, "", "", "", "", "", "",
        "", 0, 0, false, 0, <ImproveChange>[]);
  }

  // Passing data dari corousel ke change Improve
  ImproveMinResponse? _improveDataPass;
  ImproveMinResponse? get improveDataPass => _improveDataPass;
  void setImproveDataPass(ImproveMinResponse payload) {
    _improveDataPass = payload;
  }

  // return future true jika incremet/decrement improve berhasil
  Future<bool> incrementImprovement(
      String id, ImproveChangeRequest payload) async {
    setState(ViewState.busy);
    String error = "";

    try {
      final ImproveDetailResponse response =
          await _improveService.changeImprove(id, payload);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _improveDetail = response.data!;
      }
    } catch (e) {
      error = e.toString();
    }

    if (error.isNotEmpty) {
      return Future<bool>.error(error);
    }

    await findImprove(loading: false);
    return true;
  }

  // return future true jika add improve berhasil
  // memanggil findimprove sehingga tidak perlu notifyListener
  Future<bool> addImprove(ImproveRequest payload) async {
    setState(ViewState.busy);
    String error = "";

    try {
      final MessageResponse response =
          await _improveService.createImprove(payload);
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
    await findImprove(loading: false);
    return true;
  }

  // return future ImproveDetail jika edit improve berhasil
  Future<bool> editImprove(ImproveEditRequest payload) async {
    setState(ViewState.busy);
    String error = "";

    try {
      final ImproveDetailResponse response =
          await _improveService.editImprove(_detailIDSaved, payload);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _improveDetail = response.data!;
      }
    } catch (e) {
      error = e.toString();
    }

    setState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future<bool>.error(error);
    }

    await findImprove(loading: false);
    return true;
  }

  // enabling improve
  // * mengubah status enable  improve
  Future<void> enabling() async {
    setDetailState(ViewState.busy);

    String error = "";
    try {
      final ImproveDetailResponse response =
          await _improveService.enableImprove(_detailIDSaved);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _improveDetail = response.data!;
      }
    } catch (e) {
      error = e.toString();
    }

    setDetailState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future<void>.error(error);
    }
  }

  void onClose() {
    removeDetail();
  }
}
