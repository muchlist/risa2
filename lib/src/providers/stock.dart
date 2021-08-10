import 'dart:collection';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:risa2/src/api/json_models/response/message_resp.dart';

import '../api/filter_models/stock_filter.dart';
import '../api/json_models/option/stock_category.dart';
import '../api/json_models/request/stock_change_req.dart';
import '../api/json_models/request/stock_edit_req.dart';
import '../api/json_models/request/stock_req.dart';
import '../api/json_models/response/stock_list_resp.dart';
import '../api/json_models/response/stock_resp.dart';
import '../api/services/stock_service.dart';
import '../globals.dart';
import '../utils/enums.dart';
import '../utils/image_compress.dart';

class StockProvider extends ChangeNotifier {
  StockProvider(this._stockService);
  final StockService _stockService;

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
  List<StockMinResponse> _stockList = <StockMinResponse>[];
  List<StockMinResponse> get stockList {
    return UnmodifiableListView<StockMinResponse>(_stockList);
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

    String error = "";
    try {
      final StockListResponse response =
          await _stockService.findStock(_filterStock);
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
      return Future<void>.error(error);
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
  StockDetailResponseData _stockDetail = StockDetailResponseData(
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
      0,
      0,
      "",
      <String>[],
      "",
      "",
      <StockChange>[],
      <StockChange>[]);
  StockDetailResponseData get stockDetail {
    return _stockDetail;
  }

  // list Stock use cache
  List<StockChange> _sortedStockUse = <StockChange>[];
  List<StockChange> get sortedStockUse {
    return _sortedStockUse;
  }

  void removeDetail() {
    _stockDetail = StockDetailResponseData(
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
        0,
        0,
        "",
        <String>[],
        "",
        "",
        <StockChange>[],
        <StockChange>[]);
  }

  // get detail stock
  // * Mendapatkan stock
  Future<void> getDetail() async {
    setDetailState(ViewState.busy);

    String error = "";
    try {
      final StockDetailResponse response =
          await _stockService.getStock(_stockIDSaved);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        final StockDetailResponseData stockData = response.data!;
        _sortedStockUse =
            _sortStockUse(stockData.increment, stockData.decrement);
        _stockDetail = stockData;
      }
    } catch (e) {
      error = e.toString();
    }

    setDetailState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future<void>.error(error);
    }
  }

  int getStockIncrementCount() {
    final List<StockChange> increment = _stockDetail.increment;
    int total = 0;
    for (final StockChange inc in increment) {
      total = total + inc.qty;
    }
    return total;
  }

  int getStockDecrementCount() {
    final List<StockChange> decrement = _stockDetail.decrement;
    int total = 0;
    for (final StockChange dec in decrement) {
      total = total + dec.qty;
    }
    return -total;
  }

  // menggabungkan pemakaian stock, anatara penambahan dan pengurangan lalu sorting
  // berdasarkan valu time unix
  List<StockChange> _sortStockUse(List<StockChange> stockUseIncrement,
      List<StockChange> stockUseDecrement) {
    if (stockUseIncrement.isEmpty && stockUseDecrement.isEmpty) {
      return <StockChange>[];
    }

    final List<StockChange> stockUseCombination = <StockChange>[
      ...stockUseIncrement,
      ...stockUseDecrement
    ]..sort((StockChange a, StockChange b) => b.time.compareTo(a.time));

    return stockUseCombination;
  }

  // return future true jika add stock berhasil
  // memanggil findStock sehingga tidak perlu notifyListener
  Future<bool> addStock(StockRequest payload) async {
    setState(ViewState.busy);
    String error = "";

    try {
      final MessageResponse response = await _stockService.createStock(payload);
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
    await findStock(loading: false);
    return true;
  }

  // stock option cache
  OptStockCategory _stockOption = OptStockCategory(<String>["None"]);
  OptStockCategory get stockOption {
    return _stockOption;
  }

  // * Mendapatkan check option
  Future<void> findOptionStock() async {
    try {
      final OptStockCategory response = await _stockService.getOptStock();
      _stockOption = response;
    } catch (e) {
      return Future<void>.error(e.toString());
    }
    notifyListeners();
  }

  // return future StockDetail jika edit stock berhasil
  Future<bool> editStock(StockEditRequest payload) async {
    setState(ViewState.busy);
    String error = "";

    try {
      final StockDetailResponse response =
          await _stockService.editStock(_stockIDSaved, payload);
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
      return Future<bool>.error(error);
    }

    await findStock(loading: false);
    return true;
  }

  // * update image
  // return future true jika update image berhasil
  Future<bool> uploadImage(String id, File file) async {
    String error = "";

    final File fileCompressed = await compressFile(file);

    try {
      final StockDetailResponse response =
          await _stockService.uploadImage(id, fileCompressed);
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
      return Future<bool>.error(error);
    }
    return true;
  }

  // remove stock
  Future<bool> removeStock() async {
    String error = "";

    try {
      final MessageResponse response =
          await _stockService.deleteStock(_stockIDSaved);
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
    await findStock(loading: false);
    return true;
  }

  // * detail state
  ViewState _stockChangeState = ViewState.idle;
  ViewState get stockChangeState => _stockChangeState;
  void setStockChangeState(ViewState viewState) {
    _stockChangeState = viewState;
    notifyListeners();
  }

  // return future true jika incremet/decrement stock berhasil
  // perbedaan increment dan decrement adalah pada payload qty plus atau minus
  Future<bool> changeStock(StockChangeRequest payload) async {
    setStockChangeState(ViewState.busy);
    String error = "";

    try {
      final StockDetailResponse response =
          await _stockService.changeStock(_stockIDSaved, payload);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        final StockDetailResponseData stockData = response.data!;
        _sortedStockUse =
            _sortStockUse(stockData.increment, stockData.decrement);
        _stockDetail = stockData;
      }
    } catch (e) {
      error = e.toString();
    }

    setStockChangeState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future<bool>.error(error);
    }

    await findStock(loading: false);
    return true;
  }
}
