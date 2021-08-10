import 'dart:io';

import 'package:dio/dio.dart';

import '../filter_models/stock_filter.dart';
import '../http_client.dart';
import '../json_models/option/stock_category.dart';
import '../json_models/request/stock_change_req.dart';
import '../json_models/request/stock_edit_req.dart';
import '../json_models/request/stock_req.dart';
import '../json_models/response/message_resp.dart';
import '../json_models/response/stock_list_resp.dart';
import '../json_models/response/stock_resp.dart';
import '../json_parsers/json_parsers.dart';

class StockService {
  const StockService();

  Future<MessageResponse> createStock(StockRequest payload) {
    return RequestREST(endpoint: "/stock", data: payload.toJson())
        .executePost<MessageResponse>(const MessageParser());
  }

  Future<StockDetailResponse> editStock(String id, StockEditRequest payload) {
    return RequestREST(endpoint: "/stock/$id", data: payload.toJson())
        .executePut<StockDetailResponse>(const StockParser());
  }

  Future<StockDetailResponse> getStock(String id) {
    return RequestREST(endpoint: "/stock/$id")
        .executeGet<StockDetailResponse>(const StockParser());
  }

  Future<StockDetailResponse> enableStock(String id) {
    return RequestREST(endpoint: "/stock-avail/$id/enable")
        .executeGet<StockDetailResponse>(const StockParser());
  }

  Future<StockDetailResponse> disableStock(String id) {
    return RequestREST(endpoint: "/stock-avail/$id/disable")
        .executeGet<StockDetailResponse>(const StockParser());
  }

  Future<MessageResponse> deleteStock(String id) {
    return RequestREST(endpoint: "/stock/$id")
        .executeDelete<MessageResponse>(const MessageParser());
  }

  Future<StockListResponse> findStock(FilterStock f) {
    String query = "";
    if (f.name != null) {
      query = query + "name=${f.name}&";
    }
    if (f.branch != null) {
      query = query + "branch=${f.branch}&";
    }
    if (f.category != null) {
      query = query + "category=${f.category}&";
    }
    if (f.disable != null) {
      query = query + "disable=${f.disable}";
    }

    return RequestREST(endpoint: "/stock?$query")
        .executeGet<StockListResponse>(const StockListParser());
  }

  Future<StockDetailResponse> changeStock(
      String id, StockChangeRequest payload) {
    return RequestREST(endpoint: "/stock-change/$id", data: payload.toJson())
        .executePost<StockDetailResponse>(StockParser());
  }

  Future<StockDetailResponse> uploadImage(String id, File file) async {
    return RequestREST(endpoint: "/stock-image/$id", data: <String, dynamic>{
      "image": await MultipartFile.fromFile(file.path)
    }).executeUpload(StockParser());
  }

  Future<OptStockCategory> getOptStock() {
    return RequestREST(endpoint: "opt-stock")
        .executeGet<OptStockCategory>(StockCategoryParser());
  }
}
