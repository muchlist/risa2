import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/json_models/response/history_list_resp.dart';
import '../globals.dart';
import '../providers/cctvs.dart';
import '../providers/stock.dart';
import '../router/routes.dart';
import '../screens/history/history_detail.dart';
import '../screens/history/history_edit.dart';
import '../utils/enums.dart';
import 'add_history_dialog.dart';
import 'add_parent_history_dialog.dart';

class HistoryHelper {
  static final HistoryHelper _historyHelper = HistoryHelper._internal();

  factory HistoryHelper() {
    return _historyHelper;
  }

  HistoryHelper._internal();

  void showAddIncident(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (context) => AddHistoryDialog(),
    );
  }

  void showAddParentIncident(
      BuildContext context, String parentID, String parentName) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (context) => AddParentHistoryDialog(
        parentID: parentID,
        parentName: parentName,
      ),
    );
  }

  void showEditIncident(
      BuildContext context, HistoryMinResponse history, bool forParent) {
    final statusInfo = history.completeStatus == enumStatus.info.index;
    final statusComplete = history.completeStatus == enumStatus.completed.index;
    if (statusInfo || statusComplete) {
      return;
    }

    final userBranch = App.getBranch();
    if (userBranch != history.branch) {
      return;
    }

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (context) => EditHistoryDialog(
        history: history,
        forParent: forParent,
      ),
    );
  }

  void showDetailIncident(BuildContext context, HistoryMinResponse history) {
    if (history.completeStatus == enumStatus.info.index) {
      return;
    }

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (context) => DetailHistoryDialog(
        history: history,
      ),
    );
  }

  void showParent(BuildContext context, HistoryMinResponse history) {
    var routeName = "";

    switch (history.category.toUpperCase()) {
      case "CCTV":
        routeName = RouteGenerator.cctvDetail;
        context.read<CctvProvider>()
          ..removeDetail()
          ..setCctvID(history.parentID);
        break;
      case "STOCK":
        routeName = RouteGenerator.stockDetail;
        context.read<StockProvider>()
          ..removeDetail()
          ..setStockID(history.parentID);
        break;
      default:
    }

    Navigator.pushNamed(context, routeName);
  }
}
