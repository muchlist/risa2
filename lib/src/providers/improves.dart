import 'dart:collection';

import 'package:flutter/material.dart';

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

  Future<void> findImprove() async {
    setState(ViewState.busy);

    final filter = FilterImporve(branch: "BANJARMASIN", limit: 3);
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
}
