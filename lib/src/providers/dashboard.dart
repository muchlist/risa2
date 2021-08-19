import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:risa2/src/api/json_models/response/message_resp.dart';

import '../api/json_models/response/pdf_list_resp.dart';
import '../api/json_models/response/speed_list_resp.dart';
import '../api/services/pdf_service.dart';
import '../api/services/speed_service.dart';
import '../globals.dart';
import '../utils/utils.dart';

class DashboardProvider extends ChangeNotifier {
  DashboardProvider(this._speedService, this._pdfService);
  final SpeedService _speedService;
  final PdfService _pdfService;

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
  List<SpeedData> _speedList = <SpeedData>[];
  List<SpeedData> get speedList {
    return UnmodifiableListView<SpeedData>(_speedList);
  }

  List<SpeedData> get lastTeenSpeedList {
    if (_speedList.length <= 10) {
      return UnmodifiableListView<SpeedData>(_speedList);
    }
    return UnmodifiableListView<SpeedData>(
        speedList.sublist(speedList.length - 1 - 10).toList());
  }

  // * Mendapatkan dashboard
  Future<void> retrieveSpeed({bool loading = true}) async {
    if (loading) {
      setState(ViewState.busy);
    }

    String error = "";
    try {
      final SpeedListResponse response = await _speedService.retrieveSpeed();
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
      return Future<void>.error(error);
    }
  }

  // PDF

  // speed list cache
  List<PdfData> _pdfList = <PdfData>[];
  List<PdfData> get pdfList {
    return UnmodifiableListView<PdfData>(_pdfList);
  }

  // * Mendapatkan pdf
  Future<void> findPdf({bool loading = true, String pdfType = ""}) async {
    if (loading) {
      setState(ViewState.busy);
    }

    String error = "";
    try {
      final PdfListResponse response = await _pdfService.findPDF(type: pdfType);
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
      return Future<void>.error(error);
    }
  }

  // generate PDF
  Future<bool> generatePDF(int start, int end, bool forVendor) async {
    setState(ViewState.busy);
    String error = "";

    try {
      final MessageResponse response = forVendor
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
      return Future<bool>.error(error);
    }

    await findPdf(loading: false, pdfType: forVendor ? "VENDOR" : "LAPORAN");
    return true;
  }

  // generate PDF Auto
  Future<bool> generatePDFAuto(bool forVendor) async {
    setState(ViewState.busy);
    String error = "";

    try {
      final MessageResponse response = forVendor
          ? await _pdfService.generatePDFforVendorAuto(App.getBranch() ?? "")
          : await _pdfService.generatePDFAuto(App.getBranch() ?? "");
      if (response.error != null) {
        error = response.error!.message;
      }
    } catch (e) {
      error = e.toString();
    }

    setState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future<bool>.error(error);
    }

    await findPdf(loading: false, pdfType: forVendor ? "VENDOR" : "LAPORAN");
    return true;
  }

  // dipanggil ketika data sudah tidak dibutuhkan lagi,
  // di on dispose
  void onClose() {
    _speedList = <SpeedData>[];
    _pdfList = <PdfData>[];
  }
}
