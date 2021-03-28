import 'package:flutter/material.dart';
import 'package:risa2/src/api/filter_models/improve_filter.dart';
import 'package:risa2/src/api/json_models/response/improve_list_resp.dart';
import 'package:risa2/src/api/services/improve_service.dart';

class ImproveProvider extends ChangeNotifier {
  List<ImproveMinResponse> _improveList = [
    ImproveMinResponse(
        "",
        0,
        0,
        "",
        "Welcome to Risa",
        "Risa adalah porting anti life equations yang dijadikan aplikasi android. Bersembunyilah dari darkseid",
        0,
        0,
        true,
        1)
  ];

  List<ImproveMinResponse> get improveList {
    return [..._improveList];
  }

  String? _error;
  String? get error => _error;
  void removeError() {
    _error = null;
  }

  void findImprove() async {
    removeError();
    final filter = FilterImporve(branch: "BANJARMASIN", limit: 3);
    await ImproveService().findImprove(filter).then((response) {
      if (response.data.length != 0) {
        _improveList = response.data;
      } else if (response.error != null) {
        _error = response.error!.message;
      }
    }, onError: (exeption) {
      _error = exeption.toString();
    });
    notifyListeners();
  }
}
