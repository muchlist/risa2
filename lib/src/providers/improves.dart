import 'package:flutter/material.dart';
import '../api/filter_models/improve_filter.dart';
import '../api/json_models/response/improve_list_resp.dart';
import '../api/services/improve_service.dart';

class ImproveProvider extends ChangeNotifier {
  List<ImproveMinResponse> _improveList = [
    ImproveMinResponse(
        "", 0, 0, "", "Loading ...", "Loading, please standby!", 0, 0, true, 1)
  ];

  List<ImproveMinResponse> get improveList {
    return [..._improveList];
  }

  Future<void> findImprove() {
    final filter = FilterImporve(branch: "BANJARMASIN", limit: 3);
    return ImproveService().findImprove(filter).then(
      (response) {
        if (response.data.length != 0) {
          _improveList = response.data;
          notifyListeners();
        } else if (response.error != null) {
          _improveList = [
            ImproveMinResponse("", 0, 0, "", "Error ...",
                response.error!.message, 0, 0, true, 1)
          ];
          notifyListeners();
          return Future.error(response.error!.message);
        }
      },
    ).onError((error, _) {
      _improveList = [
        ImproveMinResponse(
            "", 0, 0, "", "Error ...", error.toString(), 0, 0, true, 1)
      ];
      notifyListeners();
      return Future.error(error.toString());
    });
  }
}
