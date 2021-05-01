import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:risa2/src/api/json_models/response/stock_resp.dart';
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

// ========================================================
  // detail stock

  // * detail state
  ViewState _detailState = ViewState.idle;
  ViewState get detailState => _detailState;
  void setDetailState(ViewState viewState) {
    _detailState = viewState;
    notifyListeners();
  }

  String _stockIDSaved = "";
  void setStockID(String stockID) {
    _stockIDSaved = stockID;
  }

  // stock detail cache
  StockDetailResponseData _stockDetail = StockDetailResponseData("", 0, 0, "",
      "", "", "", "", false, "", "", "", 0, 0, "", [], "", "", [], []);
  StockDetailResponseData get stockDetail {
    return _stockDetail;
  }

  void removeDetail() {
    _stockDetail = StockDetailResponseData("", 0, 0, "", "", "", "", "", false,
        "", "", "", 0, 0, "", [], "", "", [], []);
  }

  // get detail stock
  // * Mendapatkan stock
  Future<void> getDetail() async {
    setDetailState(ViewState.busy);

    var error = "";
    try {
      final response = await _stockService.getStock(_stockIDSaved);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _stockDetail = response.data!;
      }
    } catch (e) {
      error = e.toString();
    }

    setDetailState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future.error(error);
    }
  }

  int getStockIncrementCount() {
    final increment = _stockDetail.increment;
    var total = 0;
    for (var inc in increment) {
      total = total + inc.qty;
    }
    return total;
  }

  int getStockDecrementCount() {
    final decrement = _stockDetail.decrement;
    var total = 0;
    for (var dec in decrement) {
      total = total + dec.qty;
    }
    return total;
  }
}
