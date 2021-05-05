import 'dart:collection';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:risa2/src/api/json_models/request/stock_edit_req.dart';
import 'package:risa2/src/utils/image_compress.dart';

import '../api/filter_models/stock_filter.dart';
import '../api/json_models/option/stock_category.dart';
import '../api/json_models/request/stock_req.dart';
import '../api/json_models/response/stock_list_resp.dart';
import '../api/json_models/response/stock_resp.dart';
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
  Future<void> findStock({bool loading = true}) async {
    if (loading) {
      setState(ViewState.busy);
    }

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

  // list Stock use cache
  List<StockChange> _sortedStockUse = [];
  List<StockChange> get sortedStockUse {
    return _sortedStockUse;
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
        final stockData = response.data!;
        _sortedStockUse =
            _sortStockUse(stockData.increment, stockData.decrement);
        _stockDetail = stockData;
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
    return -total;
  }

  // menggabungkan pemakaian stock, anatara penambahan dan pengurangan lalu sorting
  // berdasarkan valu time unix
  List<StockChange> _sortStockUse(List<StockChange> stockUseIncrement,
      List<StockChange> stockUseDecrement) {
    if (stockUseIncrement.length == 0 && stockUseDecrement.length == 0) {
      return [];
    }

    var stockUseCombination = [...stockUseIncrement, ...stockUseDecrement]
      ..sort((a, b) => b.time.compareTo(a.time));

    return stockUseCombination;
  }

  // return future true jika add stock berhasil
  // memanggil findStock sehingga tidak perlu notifyListener
  Future<bool> addStock(StockRequest payload) async {
    setState(ViewState.busy);
    var error = "";

    try {
      final response = await _stockService.createStock(payload);
      if (response.error != null) {
        error = response.error!.message;
      }
    } catch (e) {
      error = e.toString();
    }

    setState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future.error(error);
    }
    await findStock(loading: false);
    return true;
  }

  // stock option cache
  OptStockCategory _stockOption = OptStockCategory(["None"]);
  OptStockCategory get stockOption {
    return _stockOption;
  }

  // * Mendapatkan check option
  Future<void> findOptionStock() async {
    try {
      final response = await _stockService.getOptStock();
      _stockOption = response;
    } catch (e) {
      return Future.error(e.toString());
    }
    notifyListeners();
  }

  // return future StockDetail jika edit stock berhasil
  Future<bool> editStock(StockEditRequest payload) async {
    setState(ViewState.busy);
    var error = "";

    try {
      final response = await _stockService.editStock(_stockIDSaved, payload);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _stockDetail = response.data!;
      }
    } catch (e) {
      error = e.toString();
    }

    setState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future.error(error);
    }

    await findStock(loading: false);
    return true;
  }

  // * update image
  // return future true jika update image berhasil
  Future<bool> uploadImage(String id, File file) async {
    var error = "";

    final fileCompressed = await compressFile(file);

    try {
      final response = await _stockService.uploadImage(id, fileCompressed);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _stockDetail = response.data!;
      }
    } catch (e) {
      error = e.toString();
    }

    notifyListeners();

    if (error.isNotEmpty) {
      return Future.error(error);
    }
    return true;
  }
}
