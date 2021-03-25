import 'package:flutter/material.dart';
import 'package:risa2/src/models/history_preview.dart';

class HistoryModel extends ChangeNotifier {
  // late Response response;
  // Dio dio = Dio();

  List<HistoryPreview> historyList = [
    HistoryPreview(
        title: "title",
        incidentNote: "incidentNote",
        resolveNote: "resolveNote",
        author: "author",
        completeStatus: "completeStatus",
        date: "date"),
    HistoryPreview(
        title: "title",
        incidentNote: "incidentNote",
        resolveNote: "resolveNote",
        author: "author",
        completeStatus: "completeStatus",
        date: "date"),
    HistoryPreview(
        title: "title",
        incidentNote: "incidentNote",
        resolveNote: "resolveNote",
        author: "author",
        completeStatus: "completeStatus",
        date: "date"),
  ];

  // void refreshHistory() async {
  //   try {
  //     response = await dio.get("http://localhost:3000/api/histories",
  //         options: Options(contentType: Headers.formUrlEncodedContentType));
  //     return;
  //   } on DioError catch (_) {
  //     //todo
  //   }
  //   notifyListeners();
  // }

  addHistory(HistoryPreview history) {
    historyList.add(history);
    notifyListeners();
  }
}
