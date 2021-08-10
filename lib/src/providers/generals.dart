import 'dart:collection';

import 'package:flutter/material.dart';

import '../api/filter_models/general_filter.dart';
import '../api/json_models/response/general_list_resp.dart';
import '../api/services/general_service.dart';
import '../utils/enums.dart';
import '../utils/utils.dart';

class GeneralProvider extends ChangeNotifier {
  GeneralProvider(this._generalService);
  final GeneralService _generalService;

  ViewState _state = ViewState.idle;
  ViewState get state => _state;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  // general list cache
  List<GeneralMinResponse> _generalList = <GeneralMinResponse>[];

  List<GeneralMinResponse> get generalList {
    return UnmodifiableListView<GeneralMinResponse>(_generalList);
  }

  void removeGenerals() {
    _generalList = <GeneralMinResponse>[];
  }

  List<GeneralMinResponse> generalListFiltered(String search) {
    final UnmodifiableListView<GeneralMinResponse> generalCopy =
        UnmodifiableListView<GeneralMinResponse>(_generalList);
    return generalCopy
        .where((GeneralMinResponse general) => general.name.contains(search))
        .toList();
  }

  // // is search loading
  // final bool _isLoading = false;
  // bool get isLoading {
  //   return _isLoading;
  // }

  // *memasang filter pada pencarian general item
  FilterGeneral _filterGeneral = FilterGeneral();
  void setFilter(FilterGeneral filter) {
    _filterGeneral = filter;
  }

  Future<void> findGeneral(String search) async {
    setState(ViewState.busy);

    // *copy value dari cache filter general dan ganti namanya dengan input
    FilterGeneral filter =
        FilterGeneral(name: search, category: _filterGeneral.category);

    if (ValueValidator().ip(search) && search != "0.0.0.0") {
      filter = FilterGeneral(
          name: "", ip: search, category: _filterGeneral.category);
    }

    setState(ViewState.busy);

    String error = "";
    try {
      final GeneralListResponse response =
          await _generalService.findGeneral(filter);
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
      return Future<void>.error(error);
    }
  }
}
