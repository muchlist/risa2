import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/json_models/response/history_list_resp.dart';
import '../globals.dart';
import '../providers/cctvs.dart';
import '../providers/computers.dart';
import '../providers/others.dart';
import '../providers/stock.dart';
import '../router/routes.dart';
import '../screens/history/add_history_dialog.dart';
import '../screens/history/add_parent_history_dialog.dart';
import '../screens/history/detail_history_dialog.dart';
import '../screens/history/edit_history_dialog.dart';
import '../utils/enums.dart';

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

  void showParent(
      {required BuildContext context,
      required String category,
      required String parentID}) {
    var routeName = "";

    switch (category.toUpperCase()) {
      case "CCTV":
        routeName = RouteGenerator.cctvDetail;
        context.read<CctvProvider>()
          ..removeDetail()
          ..setCctvID(parentID);
        break;
      case "STOCK":
        routeName = RouteGenerator.stockDetail;
        context.read<StockProvider>()
          ..removeDetail()
          ..setStockID(parentID);
        break;
      case "PC":
        routeName = RouteGenerator.computerDetail;
        context.read<ComputerProvider>()
          ..removeDetail()
          ..setComputerID(parentID);
        break;
      case "UPS":
        routeName = RouteGenerator.otherDetail;
        context.read<OtherProvider>()
          ..setSubCategory("UPS")
          ..removeDetail()
          ..setOtherID(parentID);
        break;
      case "APPLICATION":
        routeName = RouteGenerator.otherDetail;
        context.read<OtherProvider>()
          ..setSubCategory("APPLICATION")
          ..removeDetail()
          ..setOtherID(parentID);
        break;
      case "PRINTER":
        routeName = RouteGenerator.otherDetail;
        context.read<OtherProvider>()
          ..setSubCategory("PRINTER")
          ..removeDetail()
          ..setOtherID(parentID);
        break;
      case "HANDHELD":
        routeName = RouteGenerator.otherDetail;
        context.read<OtherProvider>()
          ..setSubCategory("HANDHELD")
          ..removeDetail()
          ..setOtherID(parentID);
        break;
      case "ALTAI":
        routeName = RouteGenerator.otherDetail;
        context.read<OtherProvider>()
          ..setSubCategory("ALTAI")
          ..removeDetail()
          ..setOtherID(parentID);
        break;
      case "SERVER":
        routeName = RouteGenerator.otherDetail;
        context.read<OtherProvider>()
          ..setSubCategory("SERVER")
          ..removeDetail()
          ..setOtherID(parentID);
        break;
      case "GATE":
        routeName = RouteGenerator.otherDetail;
        context.read<OtherProvider>()
          ..setSubCategory("GATE")
          ..removeDetail()
          ..setOtherID(parentID);
        break;
      case "OTHER":
        routeName = RouteGenerator.otherDetail;
        context.read<OtherProvider>()
          ..setSubCategory("OTHER")
          ..removeDetail()
          ..setOtherID(parentID);
        break;
      default:
    }

    Navigator.pushNamed(context, routeName);
  }
}
