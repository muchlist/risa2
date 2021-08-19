import 'package:risa2/src/api/json_models/response/message_resp.dart';
import 'package:risa2/src/api/json_models/response/pdf_list_resp.dart';

import '../http_client.dart';
import '../json_parsers/json_parsers.dart';

class PdfService {
  const PdfService();
  Future<PdfListResponse> findPDF({String type = ""}) {
    return RequestREST(endpoint: "/list-pdf?type=$type")
        .executeGet<PdfListResponse>(const PdfListParser());
  }

  Future<MessageResponse> generatePDF(String branch, int start, int end) {
    //generate-pdf?branch=BANJARMASIN&start=1625721500&end=1625745096
    return RequestREST(
            endpoint: "/generate-pdf?branch=$branch&start=$start&end=$end")
        .executeGet<MessageResponse>(const MessageParser());
  }

  Future<MessageResponse> generatePDFAuto(String branch) {
    //generate-pdf-auto?branch=BANJARMASIN
    return RequestREST(endpoint: "/generate-pdf-auto?branch=$branch")
        .executeGet<MessageResponse>(const MessageParser());
  }

  Future<MessageResponse> generatePDFforVendor(
      String branch, int start, int end) {
    //generate-pdf-vendor?branch=BANJARMASIN&start=1625721500&end=1625745096
    return RequestREST(
            endpoint:
                "/generate-pdf-vendor?branch=$branch&start=$start&end=$end")
        .executeGet<MessageResponse>(const MessageParser());
  }

  Future<MessageResponse> generatePDFforVendorAuto(String branch) {
    //generate-pdf-vendor-auto?branch=BANJARMASIN
    return RequestREST(endpoint: "/generate-pdf-vendor-auto?branch=$branch")
        .executeGet<MessageResponse>(const MessageParser());
  }
}
