import 'package:flutter/material.dart';
import 'package:risa2/src/api/json_models/request/check_req.dart';
import '../api/filter_models/check_filter.dart';
import '../api/json_models/response/check_list_resp.dart';
import '../api/services/check_service.dart';

class CheckProvider extends ChangeNotifier {
  final CheckService _checkService;

  CheckProvider(this._checkService);

  // check list cache
  List<CheckMinResponse> _checkList = [];
  List<CheckMinResponse> get checkList {
    return [..._checkList];
  }

  // *memasang filter pada pencarian check
  FilterCheck _filterCheck = FilterCheck();
  void setFilter(FilterCheck filter) {
    _filterCheck = filter;
  }

  Future<void> findCheck() {
    return _checkService.findCheck(_filterCheck).then(
      (response) {
        if (response.error != null) {
          return Future.error(response.error!.message);
        } else {
          _checkList = response.data;
        }
        notifyListeners();
      },
    );
  }

  // return future true jika add check berhasil
  // memanggil findCheck sehigga tidak perlu notifyListener
  Future<bool> addCheck(CheckRequest payload) {
    return _checkService.createCheck(payload).then(
      (response) {
        if (response.error != null) {
          return Future.error(response.error!.message);
        } else if (response.data != null) {
          findCheck();
          return true;
        }
        return false;
      },
    );
  }
}
