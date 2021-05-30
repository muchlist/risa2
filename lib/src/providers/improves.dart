import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:risa2/src/api/json_models/response/improve_resp.dart';

import '../api/filter_models/improve_filter.dart';
import '../api/json_models/response/improve_list_resp.dart';
import '../api/services/improve_service.dart';
import '../utils/enums.dart';

class ImproveProvider extends ChangeNotifier {
  final ImproveService _improveService;
  ImproveProvider(this._improveService);

  ViewState _state = ViewState.idle;

  ViewState get state => _state;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  List<ImproveMinResponse> _improveList = [
    ImproveMinResponse(
        "", 0, 0, "", "Loading ...", "Loading, please standby!", 0, 0, true, 1)
  ];

  List<ImproveMinResponse> get improveList {
    return UnmodifiableListView(_improveList);
  }

  Future<void> findImprove({bool loading = true}) async {
    if (loading) {
      setState(ViewState.busy);
    }

    final filter = FilterImporve(branch: "BANJARMASIN", limit: 10);
    var error = "";

    try {
      final response = await _improveService.findImprove(filter);
      if (response.error != null) {
        _improveList = [
          ImproveMinResponse(
              "", 0, 0, "", "Error ...", response.error!.message, 0, 0, true, 1)
        ];
        error = response.error!.message;
      } else {
        _improveList = response.data;
      }
    } catch (e) {
      _improveList = [
        ImproveMinResponse(
            "", 0, 0, "", "Error ...", error.toString(), 0, 0, true, 1)
      ];
      error = e.toString();
    }

    setState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future.error(error);
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
      "", 0, 0, "", "", "", "", "", "", "", 0, 0, false, 0, []);
  ImproveDetailResponseData get improveDetail {
    return _improveDetail;
  }

  // return future true jika incremet/decrement improve berhasil
  Future<bool> incrementImprovement(ImproveChange payload) async {
    setState(ViewState.busy);
    var error = "";

    try {
      final response =
          await _improveService.changeImprove(_detailIDSaved, payload);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _improveDetail = response.data!;
      }
    } catch (e) {
      error = e.toString();
    }

    if (error.isNotEmpty) {
      return Future.error(error);
    }

    await findImprove(loading: false);
    return true;
  }
}
