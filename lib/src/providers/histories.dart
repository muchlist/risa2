import 'package:flutter/material.dart';
import '../models/history_preview.dart';

class HistoryProvider extends ChangeNotifier {
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

  addHistory(HistoryPreview history) {
    historyList.add(history);
    notifyListeners();
  }
}
