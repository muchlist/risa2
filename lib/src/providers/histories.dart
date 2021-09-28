import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:risa2/src/api/json_models/response/history_resp.dart';
import 'package:risa2/src/api/json_models/response/message_resp.dart';

import '../api/filter_models/history_filter.dart';
import '../api/json_models/request/history_edit_req.dart';
import '../api/json_models/request/history_req.dart';
import '../api/json_models/response/history_list_resp.dart';
import '../api/services/history_service.dart';
import '../config/histo_category.dart';
import '../globals.dart';
import '../utils/enums.dart';
import '../utils/image_compress.dart';

class HistoryProvider extends ChangeNotifier {
  HistoryProvider(this._historyService);
  final HistoryService _historyService;

  ViewState _state = ViewState.idle;
  ViewState get state => _state;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  List<HistoryMinResponse> _historyList = <HistoryMinResponse>[];

  // 3 history terbaru
  List<HistoryMinResponse> get historyListDashboard {
    if (_historyList.length > 4) {
      return <HistoryMinResponse>[..._historyList.sublist(0, 5)];
    }
    return UnmodifiableListView<HistoryMinResponse>(_historyList);
  }

  // history progress
  List<HistoryMinResponse> get historyProgressList {
    return _historyList.where((HistoryMinResponse hist) {
      return hist.completeStatus == enumStatus.progress.index ||
          hist.completeStatus == enumStatus.rpending.index;
    }).toList();
  }

  // history pending
  List<HistoryMinResponse> get historyPendingList {
    return _historyList
        .where((HistoryMinResponse hist) =>
            hist.completeStatus == enumStatus.pending.index)
        .toList();
  }

  // history complete
  List<HistoryMinResponse> get historyCompletedList {
    return _historyList.where((HistoryMinResponse hist) {
      return hist.completeStatus == enumStatus.completed.index;
    }).toList();
  }

  // history all
  List<HistoryMinResponse> get historyList {
    return UnmodifiableListView<HistoryMinResponse>(_historyList);
  }

  // FILTER HISTORY
  FilterHistory _filter = FilterHistory(branch: App.getBranch(), limit: 200);
  FilterHistory get filter {
    return _filter;
  }

  void setFilter(FilterHistory value) {
    if (value.category == HistCategory.all) {
      value.category = "";
    }
    _filter = value;
  }

  void resetFilter() {
    if (_filter.category?.isNotEmpty ?? false) {
      _filter = FilterHistory(branch: App.getBranch(), limit: 200);
      findHistory(loading: false);
    }
  }

  Future<void> findHistory({bool loading = true, String search = ""}) async {
    if (loading) {
      setState(ViewState.busy);
    }

    String error = "";
    try {
      HistoryListResponse response;
      if (search.isEmpty) {
        response = await _historyService.findHistoryHome(_filter);
      } else {
        response = await _historyService.findHistory(_filter, search: search);
      }

      if (response.error != null) {
        error = response.error!.message;
      } else {
        _historyList = response.data;
      }
    } catch (e) {
      error = e.toString();
    }

    setState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future<void>.error(error);
    }
  }

  // return future true jika add history berhasil
  // memanggil findHistory sehigga tidak perlu notifyListener
  // jika parentID di isi maka akan memanggil findParentHistory
  Future<bool> addHistory(HistoryRequest payload,
      {String parentID = ""}) async {
    setState(ViewState.busy);

    String error = "";
    try {
      final MessageResponse response =
          await _historyService.createHistory(payload);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        if (parentID.isNotEmpty) {
          await findParentHistory(parentID: parentID, loading: false);
          await findHistory(loading: false);
        } else {
          await findHistory(loading: false);
        }
        return true;
      }
    } catch (e) {
      error = e.toString();
    }

    setState(ViewState.idle);

    if (error.isNotEmpty) {
      return Future<bool>.error(error);
    }
    return false;
  }

  // ** PARENT HISTORY -----------------------------------------------------
  List<HistoryMinResponse> _parentHistory = <HistoryMinResponse>[];

  List<HistoryMinResponse> get parentHistory {
    return UnmodifiableListView<HistoryMinResponse>(_parentHistory);
  }

  void clearParentHistory() {
    _parentHistory = <HistoryMinResponse>[];
  }

  Future<void> findParentHistory(
      {required String parentID, bool loading = true}) async {
    if (loading) {
      setState(ViewState.busy);
    }
    String error = "";
    try {
      final HistoryListResponse response =
          await _historyService.findHistoryFromParent(parentID);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _parentHistory = response.data;
      }
    } catch (e) {
      error = e.toString();
    }

    setState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future<void>.error(error);
    }
  }

  // Edit History
  // return future true jika edit history berhasil
  // memanggil findHistory sehigga tidak perlu notifyListener
  Future<bool> editHistory(
      {required HistoryEditRequest payload, required String id}) async {
    setState(ViewState.busy);

    String error = "";
    try {
      final HistoryDetailResponse response =
          await _historyService.editHistory(id, payload);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        await findHistory(loading: false);
        return true;
      }
    } catch (e) {
      error = e.toString();
    }

    setState(ViewState.idle);

    if (error.isNotEmpty) {
      return Future<bool>.error(error);
    }
    return false;
  }

  // Edit History
  // return future true jika add history berhasil
  // memanggil findHistory sehigga tidak perlu notifyListener
  Future<bool> editHistoryForParent(
      {required HistoryEditRequest payload,
      required String id,
      required String parentID}) async {
    setState(ViewState.busy);

    String error = "";
    try {
      final HistoryDetailResponse response =
          await _historyService.editHistory(id, payload);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        await findParentHistory(parentID: parentID, loading: false);
        return true;
      }
    } catch (e) {
      error = e.toString();
    }

    setState(ViewState.idle);

    if (error.isNotEmpty) {
      return Future<bool>.error(error);
    }
    return false;
  }

  // return future true jika delete history berhasil
  // memanggil findHistory sehigga tidak perlu notifyListener
  Future<bool> deleteHistory(String historyID) async {
    setState(ViewState.busy);

    String error = "";
    try {
      final MessageResponse response =
          await _historyService.deleteHistory(historyID);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        await findHistory(loading: false);
        return true;
      }
    } catch (e) {
      error = e.toString();
    }

    setState(ViewState.idle);

    if (error.isNotEmpty) {
      return Future<bool>.error(error);
    }
    return false;
  }

  // * update image
  // return image url tanpa base jika update image berhasil
  Future<String> uploadImage(String id, File file) async {
    String imageUrl = "";
    String error = "";

    final File fileCompressed = await compressFile(file);

    try {
      final HistoryDetailResponse response =
          await _historyService.uploadImage(id, fileCompressed);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        imageUrl = response.data!.image;
        _updateImageinHistoryList(id, response.data!.image);
        _updateImageinParentHistoryList(id, response.data!.image);
      }
    } catch (e) {
      error = e.toString();
    }

    notifyListeners();

    if (error.isNotEmpty) {
      return Future<String>.error(error);
    }
    return imageUrl;
  }

  // return image url tanpa base jika update image berhasil
  Future<String> uploadImageForpath(File file) async {
    String imageUrl = "";
    String error = "";

    final File fileCompressed = await compressFile(file);

    try {
      final MessageResponse response =
          await _historyService.uploadImageForPath(fileCompressed);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        imageUrl = response.data!;
      }
    } catch (e) {
      error = e.toString();
    }
    if (error.isNotEmpty) {
      return Future<String>.error(error);
    }
    return imageUrl;
  }

  void _updateImageinHistoryList(String id, String imageUrl) {
    for (int i = 0; i < _historyList.length; i++) {
      if (_historyList[i].id == id) {
        _historyList[i].image = imageUrl;
      }
    }
  }

  void _updateImageinParentHistoryList(String id, String imageUrl) {
    for (int i = 0; i < _parentHistory.length; i++) {
      if (_parentHistory[i].id == id) {
        _parentHistory[i].image = imageUrl;
      }
    }
  }

  String getLabelStatus(double number) {
    switch (number.toInt()) {
      case 1:
        return "Progress";
      case 2:
        return "Req Pending";
      case 3:
        return "Pending";
      case 4:
        return "Completed";
      default:
        return "Progress";
    }
  }
}
