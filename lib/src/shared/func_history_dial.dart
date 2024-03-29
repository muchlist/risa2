import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/json_models/request/altai_maintenance_req.dart';
import '../api/json_models/request/cctv_maintenance_req.dart';
import '../api/json_models/response/history_list_resp.dart';
import '../globals.dart';
import '../providers/cctvs.dart';
import '../providers/computers.dart';
import '../providers/others.dart';
import '../providers/stock.dart';
import '../router/routes.dart';
import '../screens/history/add_altai_maintenance_history.dart';
import '../screens/history/add_history_showdial.dart';
import '../screens/history/add_history_v_showdial.dart';
import '../screens/history/add_maintenance_history.dart';
import '../screens/history/add_parent_history_showdial.dart';
import '../screens/history/detail_history_showdial.dart';
import '../screens/history/edit_history_showdial.dart';
import '../utils/enums.dart';

class HistoryHelper {
  factory HistoryHelper() {
    return _historyHelper;
  }

  HistoryHelper._internal();

  static final HistoryHelper _historyHelper = HistoryHelper._internal();

  void showAddIncident(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (BuildContext context) => const AddHistoryDialog(),
    );
  }

  // Khusus vendor hanya menampilkan cctv saja
  void showAddIncidentV(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (BuildContext context) => const AddHistoryVDialog(),
    );
  }

  void showAddParentIncident(
      BuildContext context, String parentID, String parentName) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (BuildContext context) => AddParentHistoryDialog(
        parentID: parentID,
        parentName: parentName,
      ),
    );
  }

  void showAddMaintenanceIncident(
      BuildContext context, String parentName, CCTVMaintUpdateRequest mtState) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (BuildContext context) => AddMaintenanceHistoryDialog(
        parentName: parentName,
        mtState: mtState,
      ),
    );
  }

  void showAddAltaiMaintenanceIncident(BuildContext context, String parentName,
      AltaiMaintUpdateRequest mtState) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (BuildContext context) => AddAltaiMaintenanceHistoryDialog(
        parentName: parentName,
        mtState: mtState,
      ),
    );
  }

  void showEditIncident(
      BuildContext context, HistoryMinResponse history, bool forParent) {
    final bool statusInfo = history.completeStatus == enumStatus.info.index;
    final bool statusComplete =
        history.completeStatus == enumStatus.completed.index;
    if (statusInfo || statusComplete) {
      return;
    }

    final String? userBranch = App.getBranch();
    if (userBranch != history.branch) {
      return;
    }

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (BuildContext context) => EditHistoryDialog(
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (BuildContext context) => DetailHistoryDialog(
        history: history,
      ),
    );
  }

  void showParent(
      {required BuildContext context,
      required String category,
      required String parentID}) {
    String routeName = "";

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
