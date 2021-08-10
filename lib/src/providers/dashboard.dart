import 'dart:collection';

import 'package:flutter/cupertino.dart';

import '../api/json_models/response/pdf_list_resp.dart';
import '../api/json_models/response/speed_list_resp.dart';
import '../api/services/pdf_service.dart';
import '../api/services/speed_service.dart';
import '../globals.dart';
import '../utils/utils.dart';

class DashboardProvider extends ChangeNotifier {
  final SpeedService _speedService;
  final PdfService _pdfService;
  DashboardProvider(this._speedService, this._pdfService);

  // =======================================================
  // List Dashboard

  // * state
  ViewState _state = ViewState.idle;
  ViewState get state => _state;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  // speed list cache
  List<SpeedData> _speedList = [];
  List<SpeedData> get speedList {
    return UnmodifiableListView(_speedList);
  }

  List<SpeedData> get lastTeenSpeedList {
    if (_speedList.length <= 10) {
      return UnmodifiableListView(_speedList);
    }
    return UnmodifiableListView(
        speedList.sublist(speedList.length - 1 - 10).toList());
  }

  // * Mendapatkan dashboard
  Future<void> retrieveSpeed({bool loading = true}) async {
    if (loading) {
      setState(ViewState.busy);
    }

    var error = "";
    try {
      final response = await _speedService.retrieveSpeed();
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _speedList = response.data;
      }
    } catch (e) {
      error = e.toString();
    }

    setState(ViewState.idle);

    if (error.isNotEmpty) {
      return Future.error(error);
    }
  }

  // PDF

  // speed list cache
  List<PdfData> _pdfList = [];
  List<PdfData> get pdfList {
    return UnmodifiableListView(_pdfList);
  }

  // * Mendapatkan pdf
  Future<void> findPdf({bool loading = true, String pdfType = ""}) async {
    if (loading) {
      setState(ViewState.busy);
    }

    var error = "";
    try {
      final response = await _pdfService.findPDF(type: pdfType);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _pdfList = response.data;
      }
    } catch (e) {
      error = e.toString();
    }

    setState(ViewState.idle);

    if (error.isNotEmpty) {
      return Future.error(error);
    }
  }

  // generate PDF
  Future<bool> generatePDF(int start, int end, bool forVendor) async {
    setState(ViewState.busy);
    var error = "";

    try {
      final response = (forVendor)
          ? await _pdfService.generatePDFforVendor(
              App.getBranch() ?? "", start, end)
          : await _pdfService.generatePDF(App.getBranch() ?? "", start, end);
      if (response.error != null) {
        error = response.error!.message;
      }
    } catch (e) {
      error = e.toString();
    }

    setState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future.error(error);
    }

    await findPdf(loading: false, pdfType: (forVendor) ? "VENDOR" : "LAPORAN");
    return true;
  }

  // dipanggil ketika data sudah tidak dibutuhkan lagi,
  // di on dispose
  void onClose() {
    _speedList = [];
    _pdfList = [];
  }
}
