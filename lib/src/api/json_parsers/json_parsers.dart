library json_parser;

export "login_parser.dart";
export "object_decoder.dart";

abstract class JsonParser<T> {
  const JsonParser();

  Future<T> parseFromJson(String json);
}
