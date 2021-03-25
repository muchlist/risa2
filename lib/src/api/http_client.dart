import 'package:dio/dio.dart';

import 'json_parsers/json_parsers.dart';

class RequestREST {
  final String endpoint;
  final Map<String, dynamic> data;

  const RequestREST({required this.endpoint, this.data = const {}});

  static final _client = Dio(BaseOptions(
    baseUrl: "http://10.4.2.21:3500/api/v1/",
    connectTimeout: 3000, // 3 second
    receiveTimeout: 5000,
    headers: <String, String>{
      "Authorization": "Bearer ",
      "Accept": "*/*",
      "Content-Type": "application/json"
    },
    followRedirects: false,
    validateStatus: (status) {
      return status! < 501;
    },
  ));

  // GET <<<<<<<<<<<
  Future<T> executeGet<T>(JsonParser<T> parser) async {
    final response = await _client.get<String>(endpoint);
    return parser.parseFromJson(response.data ?? "");
  }

  // POST <<<<<<<<<<<
  Future<T> executePost<T>(JsonParser<T> parser) async {
    final formData = FormData.fromMap(data);
    try {
      final response = await _client.post<String>(endpoint, data: formData);
      return parser.parseFromJson(response.data ?? "");
    } on DioError catch (e) {
      return Future.error(_dioErrorHandler(e));
    } catch (e) {
      return Future.error(e);
    }
  }

  String _dioErrorHandler(DioError e) {
    if (e.type == DioErrorType.connectTimeout ||
        e.type == DioErrorType.receiveTimeout) {
      return "Connection timeout";
    }
    if (e.message.contains("Connection refused")) {
      return "Connection refused";
    }
    return e.message;
  }
}
