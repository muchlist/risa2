library json_parser;

export "altai_maintenance_parser.dart";
export "cctv_maintenance_parser.dart";
export "cctv_parser.dart";
export "check_parser.dart";
export "checkp_parser.dart";
export "computer_parser.dart";
export "config_check_parser.dart";
export "general_parser.dart";
export "history_parser.dart";
export "improve_parser.dart";
export "login_parser.dart";
export "message_parser.dart";
export "object_decoder.dart";
export "option_parser.dart";
export "other_parser.dart";
export "pdf_parser.dart";
export "speed_parser.dart";
export "stock_parser.dart";
export "vendor_check_parser.dart";

abstract class JsonParser<T> {
  const JsonParser();

  Future<T> parseFromJson(String json);
}
