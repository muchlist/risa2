import 'package:flutter/material.dart';
import '../api/filter_models/general_filter.dart';
import '../api/json_models/response/general_list_resp.dart';
import '../api/services/general_service.dart';

class GeneralProvider extends ChangeNotifier {
  final GeneralService _generalService;

  GeneralProvider(this._generalService);

  // general list cache
  List<GeneralMinResponse> _generalList = [];

  List<GeneralMinResponse> get generalList {
    return [..._generalList];
  }

  List<GeneralMinResponse> generalListFiltered(String search) {
    final generalCopy = [..._generalList];
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

  Future<void> findGeneral(String search) {
    // todo string yang masuk di validasi apakah ip address atau bukan dengan regex
    // sehingga pencarian menjadi lebih pintar.

    // *copy value dari cache filter general dan ganti namanya dengan input
    final filter =
        FilterGeneral(name: search, category: _filterGeneral.category);

    return _generalService.findGeneral(filter).then(
      (response) {
        if (response.error != null) {
          return Future.error(response.error!.message);
        } else {
          _generalList = response.data;
        }
        notifyListeners();
      },
    );
  }
}
