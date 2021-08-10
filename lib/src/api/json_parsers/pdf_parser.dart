import '../json_models/response/error_resp.dart';
import '../json_models/response/pdf_list_resp.dart';
import 'json_parsers.dart';

class PdfListParser extends JsonParser<PdfListResponse>
    with ObjectDecoder<PdfListResponse> {
  const PdfListParser();

  @override
  Future<PdfListResponse> parseFromJson(String json) async {
    try {
      final Map<String, dynamic> decoded = decodeJsonObject(json);
      return PdfListResponse.fromJson(decoded);
    } catch (e) {
      return PdfListResponse(
          ErrorResp(0, e.toString(), "", <String>[]), <PdfData>[]);
    }
  }
}
