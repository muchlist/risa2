import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:risa2/src/utils/enums.dart';
import '../api/filter_models/general_filter.dart';
import '../api/json_models/response/general_list_resp.dart';
import '../api/services/general_service.dart';

class GeneralProvider extends ChangeNotifier {
  final GeneralService _generalService;

  GeneralProvider(this._generalService);

  ViewState _state = ViewState.idle;
  ViewState get state => _state;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  // general list cache
  List<GeneralMinResponse> _generalList = [];

  List<GeneralMinResponse> get generalList {
    return UnmodifiableListView(_generalList);
  }

  List<GeneralMinResponse> generalListFiltered(String search) {
    final generalCopy = UnmodifiableListView(_generalList);
    return generalCopy
        .where((general) => general.name.contains(search))
        .toList();
  }

  // is search loading
  bool _isLoading = false;
  bool get isLoading {
    return _isLoading;
  }

  // *memasang filter pada pencarian general item
  FilterGeneral _filterGeneral = FilterGeneral();
  void setFilter(FilterGeneral filter) {
    _filterGeneral = filter;
  }

  Future<void> findGeneral(String search) async {
    setState(ViewState.busy);

    // todo string yang masuk di validasi apakah ip address atau bukan dengan regex
    // sehingga pencarian menjadi lebih pintar.

    // *copy value dari cache filter general dan ganti namanya dengan input
    final filter =
        FilterGeneral(name: search, category: _filterGeneral.category);

    setState(ViewState.busy);

    var error = "";
    try {
      final response = await _generalService.findGeneral(filter);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _generalList = response.data;
      }
    } catch (e) {
      error = e.toString();
    }

    setState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future.error(error);
    }
  }
}
