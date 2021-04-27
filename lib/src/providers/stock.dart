import 'dart:collection';

import 'package:flutter/cupertino.dart';
import '../api/filter_models/stock_filter.dart';
import '../api/json_models/response/stock_list_resp.dart';
import '../api/services/stock_service.dart';
import '../globals.dart';
import '../utils/enums.dart';

class StockProvider extends ChangeNotifier {
  final StockService _stockService;
  StockProvider(this._stockService);

  // =======================================================
  // List Stock

  // * state
  ViewState _state = ViewState.idle;
  ViewState get state => _state;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  // stock list cache
  List<StockMinResponse> _stockList = [];
  List<StockMinResponse> get stockList {
    return UnmodifiableListView(_stockList);
  }

  // *memasang filter pada pencarian stock
  FilterStock _filterStock = FilterStock(
    branch: App.getBranch(),
  );
  void setFilter(FilterStock filter) {
    _filterStock = filter;
  }

  // * Mendapatkan stock
  Future<void> findStock() async {
    setState(ViewState.busy);

    var error = "";
    try {
      final response = await _stockService.findStock(_filterStock);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _stockList = response.data;
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
